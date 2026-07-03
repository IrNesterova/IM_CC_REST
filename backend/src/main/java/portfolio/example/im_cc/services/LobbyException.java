package portfolio.example.im_cc.services;

public class LobbyException extends RuntimeException{
    public enum Reason {
        ROOM_NOT_FOUND,
        ROOM_CLOSED,
        ALREADY_MEMBER,
        NOT_GM,
        MEMBER_NOT_FOUND
    }

    private final Reason reason;

    public LobbyException(Reason reason, String message) {
        super(message);
        this.reason = reason;
    }

    public Reason getReason() {
        return reason;
    }
}
