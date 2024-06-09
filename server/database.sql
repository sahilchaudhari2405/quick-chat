CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_verification (
    user_id VARCHAR(255) REFERENCES Users(user_id),
    verification_code VARCHAR(45) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id)
);
CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES Users(user_id),
    device_id VARCHAR(120) UNIQUE NOT NULL,
    type VARCHAR(45),
    device_token VARCHAR(120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE access (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES Users(user_id),
    device_id INT REFERENCES devices(id),
    
    token VARCHAR(60) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);
CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES Users(user_id),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    bio TEXT,
    profile_picture VARCHAR(255),
    is_active BOOL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_contact (
    user_id VARCHAR(255)REFERENCES Users(user_id),
    contact_id VARCHAR(255) REFERENCES Users(user_id),
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    bio TEXT,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, contact_id)
);
CREATE TABLE block_list (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES Users(user_id),
    participant_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE conversation (
    id SERIAL PRIMARY KEY,
    title VARCHAR(40),
    channel_id VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE participants (
    id SERIAL PRIMARY KEY,
    conversation_id INT REFERENCES conversation(id),
    user_id INT REFERENCES Users(id),
    type VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    conversation_id INT REFERENCES conversation(id),
    sender_id INT REFERENCES Users(id),
    message_type VARCHAR(20),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);
CREATE TABLE attachments (
    id SERIAL PRIMARY KEY,
    message_id INT REFERENCES messages(id),
    thumb_url VARCHAR(255),
    file_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE deleted_conversations (
    id SERIAL PRIMARY KEY,
    conversation_id INT REFERENCES conversation(id),
    user_id INT REFERENCES Users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE deleted_messages (
    id SERIAL PRIMARY KEY,
    message_id INT REFERENCES messages(id),
    user_id INT REFERENCES Users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(id),
    participant_id INT REFERENCES Users(id),
    report_type VARCHAR(45),
    notes TEXT,
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE activities (
    id SERIAL PRIMARY KEY,
    activity_type VARCHAR(45),
    activity_id INT,
    title VARCHAR(45),
    detail TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
