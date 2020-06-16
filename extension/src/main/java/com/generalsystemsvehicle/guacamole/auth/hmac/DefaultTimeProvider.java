package com.generalsystemsvehicle.guacamole.auth.hmac;

public class DefaultTimeProvider implements TimeProviderInterface {
    public long currentTimeMillis() {
        return System.currentTimeMillis();
    }
}
