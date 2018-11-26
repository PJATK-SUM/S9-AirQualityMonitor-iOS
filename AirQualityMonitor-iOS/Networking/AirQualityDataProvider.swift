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
    func didSubscribe(to topic: Topic) -> Void
    func didUnsubscribe(from topic: Topic) -> Void
    func didReceiveMessage(_ message: String?, topic: Topic) -> Void
}

protocol AirQualityDataProviderProtocol {
    func subscribe(to topics: [Topic])
    func subscribe(to topic: Topic)
    func unsubscribe(from topics: [Topic])
    func unsubscribe(from topic: Topic)
}

final class AirQualityDataProvider: AirQualityDataProviderProtocol {
    
    // MARK: - Internals
    
    private let mqtt: CocoaMQTT
    
    var delegate: AirQualityDataProviderDelegate?
    
    // MARK: - Init
    
    init() {
        self.mqtt = CocoaMQTT(clientID: "CocoaMQTT-" + String(ProcessInfo().processIdentifier),
                              host: Credentials.host,
                              port: Credentials.port)
        setupMQTT()
    }
    
    // MARk: - Setup
    
    private func setupMQTT() {
        mqtt.username = Credentials.username
        mqtt.password = Credentials.api_key
        mqtt.keepAlive = 60
        mqtt.delegate = self
        mqtt.connect()
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
        static let host: String = "io.adafruit.com"
        static let port: UInt16 = 1883
        static let username: String = "ziembinski_j"
        static let api_key: String = "a687090625a34d7d957ea107a04705ea"
    }
}

extension AirQualityDataProvider: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.delegate?.didConnect()
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        self.delegate?.didSubscribe(to: Topic.from(path: topic))
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        self.delegate?.didUnsubscribe(from: Topic.from(path: topic))
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let topic: Topic = Topic.from(path: message.topic)
        guard topic != .unknown else { return }
        
        let messageBody: String? = message.string
        self.delegate?.didReceiveMessage(messageBody, topic: topic)
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {}
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {}
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
}
