# Design Document

By TIZIANO MONTENEGRO

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?

The purpose of this database is to store, organize, and manage code snippets created by developers. The database allows users to save snippets for personal use or share them publicly with the community. It also supports user interaction features such as liking and commenting on public snippets.

* Which people, places, things, etc. are you including in the scope of your database?

- Users who create, view, and interact with snippets.
- Snippets that can be public or private.
- Programming languages associated with snippets.
- Likes and comments made by users on public snippets.

* Which people, places, things, etc. are *outside* the scope of your database?

- Full-fledged source code hosting (like GitHub).
- Version control of snippets.
- Advanced social features such as following users or messaging.

## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?

- Create an account and log in.
- Create, update, and delete their own snippets.
- Set snippet visibility (private or public).
- View public snippets created by other users.
- Like or unlike public snippets.
- Leave comments on public snippets.

* What's beyond the scope of what a user should be able to do with your database?

- Real-time collaboration or code editing.
- Full IDE or debugging environment.
- Advanced analytics or recommendation system.

## Representation

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?

The entities I choose was: Users, Snippets, Languages, Likes, Comments

* What attributes will those entities have?

- Users Attributes: id, username, email, password_hash, created_at.
- Snippets Attributes: id, title, description, code, visibility, created_at, user_id, language_id.
- Languages Attributes: id, name.
- Likes Attributes: id, user_id, snippet_id.
- Comments Attributes: id, user_id, snippet_id, content, created_at.

* Why did you choose the types you did?

- Referential integrity (foreign keys with ON DELETE actions).
- Efficient lookups (integer primary keys).

* Why did you choose the constraints you did?

- Flexibility for text fields like description and code.

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

- User → Snippets: One-to-many (a user can have many snippets).
- User → Likes: One-to-many (a user can like many snippets).
- User → Comments: One-to-many (a user can leave many comments).
- Snippet → Likes: One-to-many (a snippet can have many likes).
- Snippet → Comments: One-to-many (a snippet can have many comments).
- Snippet → Language: Many-to-one (a snippet belongs to one language).

![snippets-db](ERD.png)

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g. indexes, views) did you create? Why?

- Indexes:
    - Index on users.email and users.name for fast login and lookup.
    - Index on snippets.title for quicker search by title.
    - Index on likes.snippet_id and comments.snippet_id for fast retrieval of interactions.
- Constraints:
    - Unique constraints to prevent duplicate likes by the same user.
    - Not null constraints on required fields (e.g. snippet.title, comment.content).

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
* What might your database not be able to represent very well?

The database does not support snippet versioning, so users cannot track changes over time. 
And large code snippets may not be efficiently handled if the system is scaled to millions of users without further optimization.

The worst problem I think is that it does not manage user authentication beyond storing password hashes (no tokens, sessions, or OAuth).

A limitation in social terms are that users can't follow other users, and there are no private messaging.
