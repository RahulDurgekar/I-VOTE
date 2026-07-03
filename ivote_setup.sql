-- ================================================================
--  I-VOTE  —  Database Setup Script  (v2)
--  Run this entire file in MySQL Workbench in one click.
--  Database: jdbc-db
-- ================================================================

CREATE DATABASE IF NOT EXISTS `jdbc-db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `jdbc-db`;

-- ----------------------------------------------------------------
-- Drop tables in reverse FK order (safe re-run)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS elections;
DROP TABLE IF EXISTS users;

-- ----------------------------------------------------------------
-- USERS
-- role: ADMIN (only seeded) | USER (self-registered)
-- phone: unique — used to enforce one vote per phone per election
-- profile_pic: BLOB for user avatar
-- ----------------------------------------------------------------
CREATE TABLE users (
  id          INT          AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  phone       VARCHAR(20)  NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  role        ENUM('ADMIN','USER') NOT NULL DEFAULT 'USER',
  profile_pic MEDIUMBLOB   NULL,
  created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ----------------------------------------------------------------
-- ELECTIONS
-- institution_name: the school / college hosting this election
-- election_code: 8-char unique code shared with participants
-- ----------------------------------------------------------------
CREATE TABLE elections (
  id               INT          AUTO_INCREMENT PRIMARY KEY,
  title            VARCHAR(200) NOT NULL,
  description      TEXT         NULL,
  institution_name VARCHAR(200) NOT NULL,
  election_code    VARCHAR(20)  NOT NULL UNIQUE,
  status           ENUM('UPCOMING','ACTIVE','CLOSED') NOT NULL DEFAULT 'UPCOMING',
  start_time       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_time         TIMESTAMP    NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL 7 DAY),
  created_by       INT          NOT NULL,
  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ----------------------------------------------------------------
-- CANDIDATES
-- profile_pic: BLOB for candidate campaign photo
-- UNIQUE(user_id, election_id) — one registration per election
-- ----------------------------------------------------------------
CREATE TABLE candidates (
  id           INT       AUTO_INCREMENT PRIMARY KEY,
  user_id      INT       NOT NULL,
  election_id  INT       NOT NULL,
  manifesto    TEXT      NULL,
  profile_pic  MEDIUMBLOB NULL,
  registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_candidate (user_id, election_id),
  FOREIGN KEY (user_id)     REFERENCES users(id)     ON DELETE CASCADE,
  FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------
-- VOTES
-- UNIQUE(voter_id, election_id)    — one vote per account per election
-- UNIQUE(voter_phone, election_id) — one vote per phone per election
-- voter_phone is stored (not FK) so it can be updated when user changes phone
-- ----------------------------------------------------------------
CREATE TABLE votes (
  id           INT       AUTO_INCREMENT PRIMARY KEY,
  voter_id     INT       NOT NULL,
  candidate_id INT       NOT NULL,
  election_id  INT       NOT NULL,
  voter_phone  VARCHAR(20) NOT NULL,
  voted_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_vote_account (voter_id, election_id),
  UNIQUE KEY uq_vote_phone   (voter_phone, election_id),
  FOREIGN KEY (voter_id)     REFERENCES users(id)      ON DELETE CASCADE,
  FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE,
  FOREIGN KEY (election_id)  REFERENCES elections(id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- ----------------------------------------------------------------
-- SEED: Default Admin account
-- Email: admin@ivote.com  |  Password: admin123
-- Change password after first login in production!
-- ----------------------------------------------------------------
INSERT INTO users (name, email, phone, password, role)
VALUES ('Administrator', 'admin@ivote.com', '0000000000', 'admin123', 'ADMIN');

-- ----------------------------------------------------------------
SELECT 'I-VOTE v2 database setup complete!' AS status;
-- ----------------------------------------------------------------
