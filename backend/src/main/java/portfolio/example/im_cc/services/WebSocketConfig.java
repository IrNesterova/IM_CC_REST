package portfolio.example.im_cc.services;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    private final StompSubscriptionAuthInterceptor subscriptionAuth;

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                // tighten this to your real frontend origin(s) in prod, not "*"
                .setAllowedOriginPatterns("*")
                // SockJS fallback for networks/proxies that block raw WebSocket
                .withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // In-memory broker. ONE instance on Render => this is all you need.
        // Horizontal scaling later: swap for enableStompBrokerRelay(...) backed by RabbitMQ.
        registry.enableSimpleBroker("/topic");
        // client -> server destinations get the /app prefix (unused for now — events are
        // server-pushed; clients act via REST). Wired so it's ready when you need it.
        registry.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        // Every inbound STOMP frame — including SUBSCRIBE — passes through this interceptor.
        registration.interceptors(subscriptionAuth);
    }
}
