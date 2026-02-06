-- Create table for storing Kudos
CREATE TABLE IF NOT EXISTS kudos (
    id BIGSERIAL PRIMARY KEY,
    from_user VARCHAR(255) NOT NULL,
    to_user VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster queries by user
CREATE INDEX idx_kudos_to_user ON kudos(to_user);
CREATE INDEX idx_kudos_from_user ON kudos(from_user);
