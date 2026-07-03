package portfolio.example.im_cc.services;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import portfolio.example.im_cc.models.enums.SourceBook;
import portfolio.example.im_cc.models.lobby.GameRoomMember;

import java.util.Set;
import java.util.UUID;

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type")
@JsonSubTypes({
        @JsonSubTypes.Type(value = LobbyEvent.MemberJoined.class, name = "MEMBER_JOINED"),
        @JsonSubTypes.Type(value = LobbyEvent.MemberLeft.class, name = "MEMBER_LEFT"),
        @JsonSubTypes.Type(value = LobbyEvent.CharacterSelected.class, name = "CHARACTER_SELECTED"),
        @JsonSubTypes.Type(value = LobbyEvent.RoomStatusChanged.class, name = "ROOM_STATUS_CHANGED"),
        @JsonSubTypes.Type(value = LobbyEvent.SourceBooksChanged.class, name = "SOURCE_BOOKS_CHANGED"),
        @JsonSubTypes.Type(value = LobbyEvent.PatronChanged.class, name = "PATRON_CHANGED")
})
public sealed interface LobbyEvent {
    UUID roomId();

    record MemberJoined(UUID roomId, Long userId, String username, GameRoomMember.MemberRole role)
            implements LobbyEvent {}

    record MemberLeft(UUID roomId, Long userId)
            implements LobbyEvent {}

    record CharacterSelected(UUID roomId, Long userId, Long characterId, String characterCode, String characterName)
            implements LobbyEvent {}

    record RoomStatusChanged(UUID roomId, boolean open)
            implements LobbyEvent {}

    record SourceBooksChanged(UUID roomId, Set<SourceBook> sourceBooks)
            implements LobbyEvent {}

    record PatronChanged(UUID roomId, String patronCode)
            implements LobbyEvent {}
}

