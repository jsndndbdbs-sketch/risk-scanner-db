CREATE DATABASE IF NOT EXISTS risk_scanner_db;
USE risk_scanner_db;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Scan_History (
    scan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    scan_type VARCHAR(50) NOT NULL,
    scan_target VARCHAR(255) NOT NULL,
    scan_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Scanned_Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    scan_id INT NOT NULL,
    item_name VARCHAR(150) NOT NULL,
    item_type VARCHAR(50),
    item_path VARCHAR(255),
    file_size BIGINT,
    FOREIGN KEY (scan_id) REFERENCES Scan_History(scan_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Risk_Indicators (
    indicator_id INT AUTO_INCREMENT PRIMARY KEY,
    indicator_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    severity_level ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL,
    score_weight DECIMAL(5,2) NOT NULL DEFAULT 1.00
);

CREATE TABLE Risk_Results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    scan_id INT NOT NULL,
    item_id INT NOT NULL,
    indicator_id INT NOT NULL,
    risk_score DECIMAL(5,2) NOT NULL,
    risk_level ENUM('Safe', 'Low', 'Medium', 'High', 'Critical') NOT NULL,
    details TEXT,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (scan_id) REFERENCES Scan_History(scan_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Scanned_Items(item_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (indicator_id) REFERENCES Risk_Indicators(indicator_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    scan_id INT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    total_items INT DEFAULT 0,
    high_risk_count INT DEFAULT 0,
    overall_score DECIMAL(5,2),
    summary TEXT,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (scan_id) REFERENCES Scan_History(scan_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    scan_id INT,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (scan_id) REFERENCES Scan_History(scan_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
);

INSERT INTO Users (full_name, email, password_hash, role) VALUES
('Ahmed Ali', 'ahmed@test.com', 'hashed_123', 'user'),
('Sara Mohamed', 'sara@test.com', 'hashed_456', 'user');

INSERT INTO Risk_Indicators (indicator_name, description, severity_level, score_weight) VALUES
('Malware Signature', 'Known malware pattern', 'Critical', 9.50),
('Suspicious Permission', 'Dangerous permissions', 'High', 7.00),
('Outdated Version', 'Known vulnerabilities', 'Medium', 4.50);

INSERT INTO Scan_History (user_id, scan_type, scan_target, scan_status) VALUES
(1, 'File Scan', 'C:/Downloads/app.exe', 'completed'),
(1, 'URL Scan', 'https://example.com', 'completed');

INSERT INTO Scanned_Items (scan_id, item_name, item_type, item_path, file_size) VALUES
(1, 'app.exe', 'Executable', 'C:/Downloads/app.exe', 2048000),
(1, 'config.dll', 'Library', 'C:/Downloads/config.dll', 512000);

INSERT INTO Risk_Results (scan_id, item_id, indicator_id, risk_score, risk_level, details) VALUES
(1, 1, 1, 95.00, 'Critical', 'Malware signature matched'),
(1, 2, 2, 70.50, 'High', 'Requests admin permission');

INSERT INTO Reports (scan_id, user_id, total_items, high_risk_count, overall_score, summary) VALUES
(1, 1, 2, 2, 82.75, 'High risk scan, 2 issues found');

INSERT INTO Feedback (user_id, scan_id, rating, comment) VALUES
(1, 1, 5, 'Report was clear and useful');

INSERT INTO Scan_History (user_id, scan_type, scan_target) VALUES (1, 'File Scan', 'new_file.zip');
UPDATE Scan_History SET scan_status = 'completed' WHERE scan_id = 3;
DELETE FROM Feedback WHERE feedback_id = 1;
SELECT * FROM Scan_History WHERE user_id = 1 ORDER BY scanned_at DESC;
