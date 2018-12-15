//
//  MQTTConnector.swift
//  AirQualityMonitor-iOS
//
//  Created by Jakub Ziembiński on 14/11/2018.
//  Copyright © 2018 Jakub Ziembiński. All rights reserved.
//

import CocoaMQTT

protocol AirQualityDataProviderDelegate: class {
    func didConnect() -> Void
    func didDisconnect() -> Void
    func didReceive(update value: Float, for topic: Topic) -> Void
    func didReceive(initalValues values: [Float], for topic: Topic) -> Void
    func didReceive(error: Error) -> Void
}

protocol AirQualityDataProviderProtocol {
    func subscribe(to topics: [Topic])
    func subscribe(to topic: Topic)
    func unsubscribe(from topics: [Topic])
    func unsubscribe(from topic: Topic)
    
    func start()
    func stop()
    
    var delegate: AirQualityDataProviderDelegate? { get set }
}

final class AirQualityDataProvider: AirQualityDataProviderProtocol {
    
    // MARK: - Internals
    
    private let mqtt: CocoaMQTT
    private let urlSession: URLSession
    
    var delegate: AirQualityDataProviderDelegate?
    
    private var latestMeasurementsDataTasks: [String:URLSessionDataTask]?
    
    // MARK: - Init
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
        self.mqtt = CocoaMQTT(clientID: "CocoaMQTT-" + String(ProcessInfo().processIdentifier),
                              host: Credentials.MQTT.host,
                              port: Credentials.MQTT.port)
        setupMQTT()
    }
    
    // MARk: - Setup
    
    private func setupMQTT() {
        mqtt.username = Credentials.username
        mqtt.password = Credentials.api_key
        mqtt.keepAlive = 60
        mqtt.delegate = self
    }
    
    func start() {
        mqtt.connect()
        self.getLatestData(from: Topic.all, limit: 5)
    }
    
    func stop() {
        mqtt.disconnect()
    }
    
    // MARK: - RESTful networking
    
    private func getLatestData(from topics: [Topic], limit: Int) {
        topics.forEach { self.getLatestData(from: $0, limit: limit) }
    }
    
    private func getLatestData(from topic: Topic, limit: Int) {
        let urlString = "\(Credentials.REST.api)\(topic.requestPath)/data?X-AIO-Key=\(Credentials.api_key)&limit=\(limit)"
        guard let url = URL(string: urlString) else {
            self.delegate?.didReceive(error: NetworkError.malformedURL)
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            self?.latestMeasurementsDataTasks?.removeValue(forKey: topic.rawValue)
            if let error = error {
                self?.delegate?.didReceive(error: error)
            } else if let data = data {
                do {
                    let readings = try JSONDecoder().decode(RemoteReadings.self, from: data)
                    let values = readings.map { Float($0.value)! }
                    self?.delegate?.didReceive(initalValues: values, for: topic)
                } catch {
                    self?.delegate?.didReceive(error: NetworkError.malformedData)
                }
            } else {
                self?.delegate?.didReceive(error: NetworkError.unknown)
            }
        }
        
        dataTask.resume()
        
        self.latestMeasurementsDataTasks?[topic.rawValue] = dataTask
    }
    
    // MARK: - AirQualityDataProviderProtocol
    
    func subscribe(to topics: [Topic]) {
        topics.forEach { subscribe(to: $0) }
    }
    
    func subscribe(to topic: Topic) {
        mqtt.subscribe(topic.path)
    }
    
    func unsubscribe(from topics: [Topic]) {
        topics.forEach { unsubscribe(from: $0) }
    }
    
    func unsubscribe(from topic: Topic) {
        mqtt.unsubscribe(topic.path)
    }
    
    // MARK: - Credentials
    
    private struct Credentials {
        static let username: String = "ziembinski_j"
        static let api_key: String = "a687090625a34d7d957ea107a04705ea"
        
        struct MQTT {
            static let host: String = "io.adafruit.com"
            static let port: UInt16 = 1883
        }
        
        struct REST {
            static let api: String = "https://io.adafruit.com/api/v2/"
            
        }
    }
}

extension AirQualityDataProvider: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.delegate?.didConnect()
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        self.delegate?.didDisconnect()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let topic: Topic = Topic.from(path: message.topic)
        guard
            topic != .unknown,
            let string = message.string,
            let value = Float(string)
        else {
            self.delegate?.didReceive(error: NetworkError.malformedData)
            return
        }
        
        if let dataTask = self.latestMeasurementsDataTasks?[topic.rawValue] {
            dataTask.cancel()
            self.latestMeasurementsDataTasks?.removeValue(forKey: topic.rawValue)
        }
        
        self.delegate?.didReceive(update: value, for: topic)
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {}
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
}
