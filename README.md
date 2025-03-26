# Blog Mgt Platform
- Create, edit, and delete blog posts. Store posts in posts.json with fields: id (UUID), title, content, author, tags (array), date, bookmarked (boolean).
- Add and delete comments on posts. Store comments in comments.json with id, postId, author, content, date.
- Bookmark important posts. Bookmarked posts appear at the top of the list.
- Search by post title.
- Export all posts as individual Markdown files and download as a .zip.

### API Endpoints:
* `GET /posts`: Fetch all posts in pages of 15, sorted by date in descending order, expect a `page` query parameter, and return first page when `page` is not included.
* `POST /posts`: Create a new post.
* `PATCH /posts/:id`: Update a post.
* `DELETE /posts/:id`: Delete a post.
* `GET /posts/:id/comments`: Fetch all comments for a post.
* `POST /posts/:id/comments`: Add a comment.
* `DELETE /posts/:id/comments/:id`: Delete a comment.
* `GET /posts/search`: expect a `q` query parameter and return posts that contains the text in the title, if no `q` is passed, return the first 15 posts.
* `GET /posts/export`: Export all posts as Markdown files in a ZIP.

## Installation

To get up and running with the project locally, follow the following steps.

* Clone the app

        git clone https://github.com/magicmarie/BlogMgtPlatform.git

* Move into the directory and install all the requirements.

    ```bash
    cd BlogMgtPlatform/
    ```
* Configuration

    Install the gems by running `bundle i`

* Run the application

        rackup

    Now visit [localhost:9292](http://localhost:9292)
