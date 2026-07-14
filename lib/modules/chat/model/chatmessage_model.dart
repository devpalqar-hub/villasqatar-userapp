enum MessageKind { text, offer }

class OfferDetails {
  final String amount;
  final String downPayment;
  final String financing;
  final String closingDate;

  const OfferDetails({
    required this.amount,
    required this.downPayment,
    required this.financing,
    required this.closingDate,
  });
}

class ChatMessage {
  final bool isMe;
  final MessageKind kind;
  final String? text;
  final OfferDetails? offer;
  final String time;
  final bool read;

  const ChatMessage({
    required this.isMe,
    required this.time,
    this.kind = MessageKind.text,
    this.text,
    this.offer,
    this.read = false,
  });
}

class Conversation {
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final bool online;
  final int unreadCount;
  final String? propertyPrice;

  const Conversation({
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    this.online = false,
    this.unreadCount = 0,
    this.propertyPrice,
  });
}
