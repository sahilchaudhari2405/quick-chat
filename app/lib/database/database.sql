-- Table: users
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    bio TEXT,
    profile_picture VARCHAR(255),
    is_active BOOL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table: user_verification
CREATE TABLE user_verification (
    users_id VARCHAR REFERENCES users(user_id),
    verification_code VARCHAR(45),
    created_at VARCHAR(45),
    PRIMARY KEY (users_id)
);

-- Table: devices
CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    users_id VARCHAR REFERENCES users(user_id),
    device_id VARCHAR(120),
    type VARCHAR(45),
    device_token VARCHAR(120),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table: access
CREATE TABLE access (
    id SERIAL PRIMARY KEY,
    users_id VARCHAR REFERENCES users(user_id),
    devices_id VARCHAR REFERENCES devices(device_id),
    token VARCHAR(60),
    created_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Table: block_list
CREATE TABLE block_list (
    id SERIAL PRIMARY KEY,
    users_id VARCHAR REFERENCES users(user_id),
    participants_id VARCHAR(250),
    created_at TIMESTAMP
);

-- Table: user_contact
CREATE TABLE user_contact (
    user_id INT REFERENCES users(id),
    contact_id INT,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    PRIMARY KEY (user_id, contact_id)
);

-- Table: contacts
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    user_id:VARCHAR REFERENCES Users(user_id)
    first_name VARCHAR(20),
    middle_name VARCHAR(20),
    last_name VARCHAR(20),
    phone VARCHAR(14),
    email VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table: participants
CREATE TABLE participants (
    id SERIAL PRIMARY KEY,
    conversation_id INT,
    users_id INT,
    type VARCHAR(45),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table: conversation
CREATE TABLE conversation (
    id SERIAL PRIMARY KEY,
    title VARCHAR(40),
    channel_id VARCHAR(45),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table: messages
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    conversation_id INT REFERENCES conversation(id),
    sender_id INT,
    message_type VARCHAR(20),
    message VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Table: deleted_conversations
CREATE TABLE deleted_conversations (
    id SERIAL PRIMARY KEY,
    conversation_id INT REFERENCES conversation(id),
    users_id INT,
    created_at TIMESTAMP
);

-- Table: deleted_messages
CREATE TABLE deleted_messages (
    id SERIAL PRIMARY KEY,
    messages_id INT REFERENCES messages(id),
    users_id INT,
    created_at TIMESTAMP
);

-- Table: attachments
CREATE TABLE attachments (
    id SERIAL PRIMARY KEY,
    messages_id INT REFERENCES messages(id),
    thumb_url VARCHAR(45),
    file_url VARCHAR(45),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Table: reports
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    users_id INT REFERENCES users(id),
    participants_id INT,
    report_type VARCHAR(45),
    notes TEXT,
    status VARCHAR(20),
    created_at TIMESTAMP
);

-- Table: activities
CREATE TABLE activities (
    id SERIAL PRIMARY KEY,
    activity_type VARCHAR(45),
    activity_id INT,
    title VARCHAR(45),
    detail TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
