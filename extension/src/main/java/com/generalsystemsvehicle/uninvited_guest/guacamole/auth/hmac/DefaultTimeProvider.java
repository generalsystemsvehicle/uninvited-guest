package com.generalsystemsvehicle.uninvited_guest.guacamole.auth.hmac;

public class DefaultTimeProvider implements TimeProviderInterface {
    public long currentTimeMillis() {
        return System.currentTimeMillis();
    }
}
