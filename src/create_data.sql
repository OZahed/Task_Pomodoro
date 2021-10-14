PRAGMA journal_mode=WAL;

CREATE TABLE users (
    users_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    username TEXT ,
    password TEXT NOT NULL
);

CREATE TABLE priority (
    priority_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

INSERT INTO priority (name) VALUES ("Low") , ("Normal"), ("Heigh"), ("Urgent");


CREATE TABLE pomodoro (
    pomodoro_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    Duartion INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TODO: board Like Trello 
CREATE TABLE board(
    board_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT UNIQUE NOT NULL,
    color TEXT NOT NULL,
    description TEXT
);

INSERT INTO board (title , color , description) VALUES ('Base Board', '#b8c8d1', 'Please read the docs');

CREATE TABLE tasks (
    tasks_id INTEGER PRIMARY KEY AUTOINCREMENT,
    users_id INTEGER NOT NULL,
    priority_id INTEGER NOT NULL DEFAULT 1,
    board_id INTEGER NOT NULL DEFAULT 1, 
    title TEXT NOT NULL,
    description TEXT, 
    due_time TIMESTAMP DEFAULT (datetime('now','+1 day')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    done BOOLEAN DEFAULT false,
    done_at TIMESTAMP ,

    CONSTRAINT fk_priority FOREIGN KEY (priority_id) REFERENCES priority(priority_id) ON DELETE SET NULL ,
    CONSTRAINT fk_users FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE,
    CONSTRAINT fk_users FOREIGN KEY (board_id) REFERENCES board(board_id) ON DELETE CASCADE
);

CREATE VIEW task_info_view AS
    SELECT t.tasks_id  , 
        u.username  ,
        t.title AS task_title ,
        p.name  AS priority,
        t.description  ,
        t.created_at  ,
        t.due_time  ,
        t.done ,
        t.done_at,
        b.title AS board,
        b.color
    FROM 
        tasks t 
        JOIN users u 
        USING (users_id)
        JOIN board b
        USING (board_id)
        JOIN priority p 
        USING (priority_id)
    ORDER BY created_at DESC;
