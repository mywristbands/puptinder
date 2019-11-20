### Conversations Collection
- A `conversation` is only available for read/write if `request.auth.id` is in the members list, meaning the user is part of the conversation.
- Rules will not cascade for nested paths so must also add that same rule into the `messages` subcollection.
- Aside from that, members within a conversation should be able to read all messages in the group and create in the subcollection (send a new message).
- Do not allow updates for individual documents in the `messages` subcollection, meaning cannot update messages you already sent.
### Profiles Collection
- A `profile` document can be read by anyone, but can only be written or updated if `profile_uid` equals `request.auth.id`.
- The `swiped_right` subcollection is available for read and write to the respective user.
### Matches Collection
- The `match_docs` documents are only available if `request.auth.id` is in `members` list, meaning a user can access their own matches.
