-- قواعد البيانات الخاصة بتطبيق أبو الهول للآثار الفرعونية

-- جدول المستخدمين
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) UNIQUE,
    phone VARCHAR(20),
    national_id VARCHAR(20),
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- جدول المعالم الأثرية
CREATE TABLE archaeological_sites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    location_ar VARCHAR(200),
    location_en VARCHAR(200),
    era_ar VARCHAR(100),
    era_en VARCHAR(100),
    description_ar TEXT,
    description_en TEXT,
    foreign_price DECIMAL(10, 2),
    egyptian_price DECIMAL(10, 2),
    base_price DECIMAL(10, 2),
    egyptian_base_price DECIMAL(10, 2),
    visiting_hours_ar VARCHAR(500),
    visiting_hours_en VARCHAR(500),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- جدول ملوك مصر
CREATE TABLE egyptian_kings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    era_ar VARCHAR(100),
    era_en VARCHAR(100),
    reign_period VARCHAR(100),
    description_ar TEXT,
    description_en TEXT,
    achievements_ar TEXT,
    achievements_en TEXT,
    burial_place_ar VARCHAR(200),
    burial_place_en VARCHAR(200),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- جدول الحجوزات
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_number VARCHAR(50) UNIQUE NOT NULL,
    user_id INT,
    site_id INT,
    booking_name VARCHAR(200) NOT NULL,
    booking_phone VARCHAR(20) NOT NULL,
    national_id VARCHAR(20),
    visit_date DATE NOT NULL,
    number_of_visitors INT NOT NULL,
    visitor_type ENUM('egyptian', 'foreign') NOT NULL,
    duration_hours INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    services_amount DECIMAL(10, 2) DEFAULT 0,
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    booking_status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (site_id) REFERENCES archaeological_sites(id)
);

-- جدول خدمات الحجز
CREATE TABLE booking_services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    service_type VARCHAR(100) NOT NULL,
    service_name_ar VARCHAR(200),
    service_name_en VARCHAR(200),
    price DECIMAL(10, 2) NOT NULL,
    quantity INT DEFAULT 1,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- جدول المحفظة الإلكترونية
CREATE TABLE wallets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    balance DECIMAL(10, 2) DEFAULT 0,
    password_hash VARCHAR(255),
    security_question TEXT,
    security_answer_hash VARCHAR(255),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- جدول معاملات المحفظة
CREATE TABLE wallet_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    wallet_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'payment', 'refund', 'reset') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    description_ar VARCHAR(500),
    description_en VARCHAR(500),
    reference_id VARCHAR(100),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(id)
);

-- جدول أسئلة الاختبارات
CREATE TABLE quiz_questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question_ar TEXT NOT NULL,
    question_en TEXT,
    option1_ar VARCHAR(500),
    option1_en VARCHAR(500),
    option2_ar VARCHAR(500),
    option2_en VARCHAR(500),
    option3_ar VARCHAR(500),
    option3_en VARCHAR(500),
    option4_ar VARCHAR(500),
    option4_en VARCHAR(500),
    correct_option INT NOT NULL,
    points INT DEFAULT 10,
    difficulty_level INT DEFAULT 1,
    category_ar VARCHAR(100),
    category_en VARCHAR(100),
    explanation_ar TEXT,
    explanation_en TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- جدول نتائج الاختبارات
CREATE TABLE quiz_results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    quiz_level INT NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    score INT NOT NULL,
    percentage DECIMAL(5, 2) NOT NULL,
    time_taken_seconds INT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- جدول المتصدرين
CREATE TABLE leaderboard (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    score INT NOT NULL,
    percentage DECIMAL(5, 2) NOT NULL,
    quiz_level INT,
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_score (score DESC)
);

-- جدول الإنجازات
CREATE TABLE achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name_ar VARCHAR(200) NOT NULL,
    name_en VARCHAR(200),
    description_ar TEXT,
    description_en TEXT,
    icon VARCHAR(100),
    required_score INT,
    required_tests INT,
    badge_color VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول إنجازات المستخدمين
CREATE TABLE user_achievements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (achievement_id) REFERENCES achievements(id),
    UNIQUE KEY unique_user_achievement (user_id, achievement_id)
);

-- جدول عمليات الدفع
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    payment_reference VARCHAR(100) UNIQUE NOT NULL,
    booking_id INT,
    user_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status ENUM('pending', 'processing', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    card_last_four VARCHAR(4),
    card_brand VARCHAR(50),
    transaction_id VARCHAR(200),
    installment_months INT DEFAULT 1,
    monthly_amount DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- جدول الاستفسارات والمساعدة
CREATE TABLE inquiries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(200),
    phone VARCHAR(20),
    subject_ar VARCHAR(200),
    subject_en VARCHAR(200),
    message_ar TEXT,
    message_en TEXT,
    inquiry_type ENUM('general', 'technical', 'booking', 'wallet', 'other') DEFAULT 'general',
    status ENUM('new', 'in_progress', 'resolved', 'closed') DEFAULT 'new',
    response TEXT,
    responded_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- جدول تفاعلات المساعد الذكي
CREATE TABLE ai_interactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    session_id VARCHAR(100) NOT NULL,
    user_message TEXT,
    ai_response TEXT,
    message_type ENUM('text', 'suggestion', 'feature') DEFAULT 'text',
    feature_used VARCHAR(100),
    language VARCHAR(10) DEFAULT 'ar',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_session (session_id)
);

-- جدول سجل البحث
CREATE TABLE search_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    search_query VARCHAR(500) NOT NULL,
    search_results_count INT,
    search_category VARCHAR(100),
    search_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- جدول الإعدادات العامة
CREATE TABLE app_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
    description_ar VARCHAR(500),
    description_en VARCHAR(500),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- إدراج الإعدادات الافتراضية
INSERT INTO app_settings (setting_key, setting_value, setting_type, description_ar, description_en) VALUES
('app_name', 'SPHINX - أبو الهول', 'string', 'اسم التطبيق', 'Application Name'),
('app_version', '1.0.0', 'string', 'إصدار التطبيق', 'Application Version'),
('default_language', 'ar', 'string', 'اللغة الافتراضية', 'Default Language'),
('currency', 'EGP', 'string', 'العملة الافتراضية', 'Default Currency'),
('timezone', 'Africa/Cairo', 'string', 'التوقيت الافتراضي', 'Default Timezone'),
('min_wallet_balance', '0', 'number', 'الحد الأدنى لرصيد المحفظة', 'Minimum Wallet Balance'),
('max_wallet_balance', '100000', 'number', 'الحد الأقصى لرصيد المحفظة', 'Maximum Wallet Balance'),
('booking_advance_days', '30', 'number', 'الحد الأقصى للحجز المسبق بالأيام', 'Maximum Advance Booking Days'),
('auto_cancel_hours', '24', 'number', 'ساعات الإلغاء التلقائي للحجوزات غير المدفوعة', 'Auto Cancel Hours for Unpaid Bookings'),
('quiz_time_limit_beginner', '900', 'number', 'الحد الزمني لاختبار المبتدئين بالثواني', 'Beginner Quiz Time Limit in Seconds'),
('quiz_time_limit_intermediate', '1500', 'number', 'الحد الزمني لاختبار المتوسط بالثواني', 'Intermediate Quiz Time Limit in Seconds'),
('quiz_time_limit_advanced', '1800', 'number', 'الحد الزمني لاختبار المتقدم بالثواني', 'Advanced Quiz Time Limit in Seconds');

-- إنشاء الفهارس لتحسين الأداء
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_date ON bookings(visit_date);
CREATE INDEX idx_bookings_status ON bookings(booking_status);
CREATE INDEX idx_transactions_wallet ON wallet_transactions(wallet_id);
CREATE INDEX idx_transactions_date ON wallet_transactions(created_at);
CREATE INDEX idx_quiz_results_user ON quiz_results(user_id);
CREATE INDEX idx_quiz_results_date ON quiz_results(completed_at);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_payments_date ON payments(created_at);
CREATE INDEX idx_inquiries_status ON inquiries(status);
CREATE INDEX idx_inquiries_date ON inquiries(created_at);

-- إنشاء عرض لحجوزات اليوم
CREATE VIEW today_bookings AS
SELECT 
    b.booking_number,
    b.booking_name,
    b.booking_phone,
    s.name_ar AS site_name,
    b.visit_date,
    b.number_of_visitors,
    b.total_amount,
    b.booking_status
FROM bookings b
JOIN archaeological_sites s ON b.site_id = s.id
WHERE b.visit_date = CURDATE()
ORDER BY b.visit_date;

-- إنشاء عرض للإحصائيات اليومية
CREATE VIEW daily_stats AS
SELECT 
    DATE(created_at) AS stat_date,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN booking_status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_bookings,
    SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
    SUM(total_amount) AS total_revenue,
    COUNT(DISTINCT user_id) AS unique_users
FROM bookings
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY DATE(created_at);

-- إجراء لتحديث رصيد المحفظة
DELIMITER //
CREATE PROCEDURE update_wallet_balance(
    IN p_wallet_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_transaction_type ENUM('deposit', 'withdrawal', 'payment', 'refund', 'reset'),
    IN p_description_ar VARCHAR(500),
    IN p_description_en VARCHAR(500)
)
BEGIN
    DECLARE current_balance DECIMAL(10, 2);
    
    -- الحصول على الرصيد الحالي
    SELECT balance INTO current_balance FROM wallets WHERE id = p_wallet_id;
    
    -- تحديث الرصيد بناءً على نوع المعاملة
    IF p_transaction_type = 'deposit' OR p_transaction_type = 'refund' THEN
        UPDATE wallets SET balance = current_balance + p_amount WHERE id = p_wallet_id;
    ELSEIF p_transaction_type = 'withdrawal' OR p_transaction_type = 'payment' THEN
        IF current_balance >= p_amount THEN
            UPDATE wallets SET balance = current_balance - p_amount WHERE id = p_wallet_id;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'رصيد غير كافي';
        END IF;
    ELSEIF p_transaction_type = 'reset' THEN
        UPDATE wallets SET balance = 0 WHERE id = p_wallet_id;
    END IF;
    
    -- تسجيل المعاملة
    INSERT INTO wallet_transactions (wallet_id, transaction_type, amount, description_ar, description_en)
    VALUES (p_wallet_id, p_transaction_type, p_amount, p_description_ar, p_description_en);
    
    -- تحديث وقت التحديث الأخير
    UPDATE wallets SET last_updated = CURRENT_TIMESTAMP WHERE id = p_wallet_id;
END//
DELIMITER ;

-- حدث لحذف الحجوزات القديمة غير المؤكدة تلقائياً
DELIMITER //
CREATE EVENT auto_cancel_old_bookings
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE bookings 
    SET booking_status = 'cancelled'
    WHERE booking_status = 'pending' 
    AND payment_status != 'paid'
    AND created_at < DATE_SUB(NOW(), INTERVAL 24 HOUR);
END//
DELIMITER ;

-- حدث لنسخ بيانات المتصدرين احتياطياً
DELIMITER //
CREATE EVENT backup_leaderboard
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    -- إنشاء نسخة احتياطية من المتصدرين
    INSERT INTO leaderboard_backup 
    SELECT * FROM leaderboard 
    WHERE achieved_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    -- حذف السجلات القديمة
    DELETE FROM leaderboard 
    WHERE achieved_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
END//
DELIMITER ;

-- جدول نسخ احتياطي للمتصدرين (يجب إنشاؤه مسبقاً)
CREATE TABLE leaderboard_backup LIKE leaderboard;
ALTER TABLE leaderboard_backup ADD COLUMN backup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP;