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

CREATE TABLE tag (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, 
    description TEXT 
);

CREATE TABLE pomodoro (
    pomodoro_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    Duartion INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE  task_tag_lookup  (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tasks_id INTEGER NOT NULL,
    tag_id INTEGER, 

    CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES tag(tag_id) ON DELETE CASCADE,
    CONSTRAINT fk_task FOREIGN KEY (tasks_id) REFERENCES task(tasks_id) ON DELETE CASCADE
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
    CONSTRAINT fk_users FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE
);

