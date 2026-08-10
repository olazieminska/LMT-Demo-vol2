%dw 2.0
output application/json
---
{
  eventId: "evt-" ++ (now() as String {format: "yyyyMMddHHmmssSSS"}),
  eventTime: now() as String {format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"},
  eventType: "partyCreateEvent",
  event: {
    party: payload
  }
}
