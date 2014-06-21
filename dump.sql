-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               5.1.71-community-log - MySQL Community Server (GPL)
-- ОС Сервера:                   Win32
-- HeidiSQL Версия:              8.1.0.4545
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Дамп структуры базы данных sport
CREATE DATABASE IF NOT EXISTS `sport` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sport`;


-- Дамп структуры для таблица sport.conditions
CREATE TABLE IF NOT EXISTS `conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '0',
  `mark` int(11) DEFAULT NULL,
  `active` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Состояние утром';

-- Дамп данных таблицы sport.conditions: ~6 rows (приблизительно)
DELETE FROM `conditions`;
/*!40000 ALTER TABLE `conditions` DISABLE KEYS */;
INSERT INTO `conditions` (`id`, `value`, `mark`, `active`) VALUES
	(1, 'Бодрячком', 100, 'Y'),
	(2, 'Нормальное', 80, 'Y'),
	(3, 'Вялый', 30, 'Y'),
	(4, 'Спать охота', 20, 'Y'),
	(5, 'Вчера пил', -20, 'Y'),
	(6, 'Жесткий бадунище', -200, 'Y');
/*!40000 ALTER TABLE `conditions` ENABLE KEYS */;


-- Дамп структуры для таблица sport.morning_statistics
CREATE TABLE IF NOT EXISTS `morning_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `morning_condition` int(11) NOT NULL DEFAULT '0',
  `current_condition` int(11) NOT NULL DEFAULT '0',
  `getup_time` time NOT NULL DEFAULT '00:00:00',
  `alarm_time` time NOT NULL DEFAULT '07:30:00',
  `bed_time` time NOT NULL DEFAULT '00:00:00',
  `weather` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `morning_condition` (`morning_condition`),
  KEY `current_condition` (`current_condition`),
  KEY `weather` (`weather`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='Статитистика первой авторизации в систему за день';

-- Дамп данных таблицы sport.morning_statistics: ~14 rows (приблизительно)
DELETE FROM `morning_statistics`;
/*!40000 ALTER TABLE `morning_statistics` DISABLE KEYS */;
INSERT INTO `morning_statistics` (`id`, `date`, `morning_condition`, `current_condition`, `getup_time`, `alarm_time`, `bed_time`, `weather`) VALUES
	(1, '2014-06-03 23:22:47', 2, 4, '07:45:00', '07:30:00', '00:00:00', 4),
	(2, '2014-06-04 09:55:40', 2, 2, '08:45:00', '07:30:00', '01:40:00', 4),
	(3, '2014-06-05 10:32:11', 4, 1, '09:07:00', '08:00:00', '01:00:00', 4),
	(4, '2014-06-06 00:52:16', 6, 5, '11:00:00', '09:30:00', '02:00:00', 1),
	(5, '2014-06-07 00:52:16', 6, 5, '11:00:00', '09:30:00', '02:00:00', 1),
	(6, '2014-06-08 13:55:15', 2, 3, '11:00:00', '11:00:00', '04:00:00', 1),
	(7, '2014-06-09 13:11:02', 2, 1, '09:15:00', '07:30:00', '02:00:00', 1),
	(8, '2014-06-10 07:43:46', 1, 1, '06:40:00', '08:00:00', '02:00:00', 1),
	(9, '2014-06-11 10:39:40', 1, 1, '09:00:00', '07:30:00', '02:00:00', 1),
	(10, '2014-06-12 10:29:12', 2, 2, '08:47:00', '07:30:00', '01:00:00', 4),
	(11, '2014-06-16 11:11:38', 1, 1, '08:10:00', '07:30:00', '00:00:00', 6),
	(12, '2014-06-17 09:19:34', 2, 2, '09:00:00', '07:30:00', '01:00:00', 6),
	(13, '2014-06-18 08:39:55', 1, 1, '08:10:00', '07:40:00', '00:30:00', 4),
	(14, '2014-06-19 11:34:10', 1, 1, '08:45:00', '07:40:00', '01:00:00', 6);
/*!40000 ALTER TABLE `morning_statistics` ENABLE KEYS */;


-- Дамп структуры для таблица sport.places
CREATE TABLE IF NOT EXISTS `places` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '0',
  `active` enum('Y','N') NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Места занятия спортом';

-- Дамп данных таблицы sport.places: ~4 rows (приблизительно)
DELETE FROM `places`;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
INSERT INTO `places` (`id`, `name`, `active`) VALUES
	(1, 'Работа', 'Y'),
	(2, 'Улица', 'Y'),
	(3, 'Тренажерный зал', 'Y'),
	(4, 'Дом', 'Y');
/*!40000 ALTER TABLE `places` ENABLE KEYS */;


-- Дамп структуры для таблица sport.pullups
CREATE TABLE IF NOT EXISTS `pullups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `place` int(11) DEFAULT NULL,
  `fatigue` varchar(100) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `unixtime` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `where` (`place`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=utf8 COMMENT='Информация о подтягиваниях';

-- Дамп данных таблицы sport.pullups: ~74 rows (приблизительно)
DELETE FROM `pullups`;
/*!40000 ALTER TABLE `pullups` DISABLE KEYS */;
INSERT INTO `pullups` (`id`, `uid`, `value`, `place`, `fatigue`, `timestamp`, `unixtime`) VALUES
	(1, 1, 10, 1, '7', '2014-06-03 10:19:11', NULL),
	(3, 1, 6, 1, '5', '2014-06-03 10:56:58', NULL),
	(4, 1, 7, 1, '5', '2014-06-03 11:22:03', NULL),
	(5, 1, 10, 1, '5', '2014-06-03 11:41:17', NULL),
	(6, 1, 3, 1, '2', '2014-06-03 14:56:48', NULL),
	(8, 1, 6, 1, NULL, '2014-06-03 17:26:48', NULL),
	(9, 1, 10, 1, NULL, '2014-06-03 17:26:51', NULL),
	(10, NULL, 6, 1, NULL, '2014-06-03 17:36:49', NULL),
	(11, NULL, 7, 1, NULL, '2014-06-03 17:36:53', NULL),
	(12, NULL, 15, 1, NULL, '2014-06-04 09:57:35', NULL),
	(13, NULL, 5, 1, '5', '2014-06-04 10:45:42', NULL),
	(14, NULL, 5, 1, '2', '2014-06-04 12:32:26', NULL),
	(15, NULL, 11, 1, '6', '2014-06-04 12:43:40', NULL),
	(16, NULL, 8, 1, '7', '2014-06-04 16:22:38', NULL),
	(17, NULL, 12, 1, '6', '2014-06-04 18:14:42', NULL),
	(18, NULL, 7, 1, '2', '2014-06-05 10:32:25', NULL),
	(19, NULL, 6, 1, '5', '2014-06-05 11:12:25', NULL),
	(20, NULL, 8, 1, '5', '2014-06-05 12:45:39', NULL),
	(21, NULL, 4, 1, '5', '2014-06-05 13:22:20', NULL),
	(22, NULL, 5, 1, '5', '2014-06-05 13:29:54', NULL),
	(23, NULL, 7, 1, '5', '2014-06-05 14:12:14', NULL),
	(24, NULL, 7, 1, '6', '2014-06-05 17:30:15', NULL),
	(25, NULL, 1, 4, '5', '2014-06-08 22:39:11', NULL),
	(26, NULL, 23, 1, '5', '2014-06-09 13:25:30', NULL),
	(27, NULL, 5, 1, '5', '2014-06-09 15:24:32', NULL),
	(28, NULL, 8, 1, '5', '2014-06-09 15:53:54', NULL),
	(29, NULL, 10, 1, '5', '2014-06-09 16:10:35', NULL),
	(30, NULL, 8, 1, '5', '2014-06-09 17:14:27', NULL),
	(31, NULL, 7, 1, '5', '2014-06-10 08:50:49', NULL),
	(32, NULL, 14, 1, '5', '2014-06-10 10:25:10', NULL),
	(33, NULL, 6, 1, '5', '2014-06-10 10:57:27', NULL),
	(34, NULL, 7, 1, '5', '2014-06-10 12:36:48', NULL),
	(35, NULL, 5, 1, '3', '2014-06-10 12:41:17', NULL),
	(36, NULL, 10, 1, '5', '2014-06-10 16:27:50', NULL),
	(37, NULL, 5, 1, '5', '2014-06-10 16:35:59', NULL),
	(38, NULL, 13, 1, '5', '2014-06-11 11:31:35', NULL),
	(39, NULL, 10, 1, '5', '2014-06-11 12:02:33', NULL),
	(40, NULL, 7, 1, '5', '2014-06-11 12:35:14', NULL),
	(41, NULL, 10, 1, '5', '2014-06-11 17:15:17', NULL),
	(42, NULL, 10, 1, '5', '2014-06-11 17:31:44', NULL),
	(43, NULL, 12, 1, '5', '2014-06-12 10:29:37', NULL),
	(44, NULL, 20, 1, '7', '2014-06-12 11:23:09', NULL),
	(45, NULL, 10, 1, '5', '2014-06-12 12:33:41', NULL),
	(46, NULL, 8, 1, '5', '2014-06-12 13:00:45', NULL),
	(47, NULL, 23, 1, '5', '2014-06-12 17:06:18', NULL),
	(48, NULL, 9, 1, '5', '2014-06-16 11:11:55', NULL),
	(49, NULL, 8, 1, '5', '2014-06-16 11:50:03', NULL),
	(50, NULL, 6, 1, '5', '2014-06-16 11:50:06', NULL),
	(51, NULL, 7, 1, '5', '2014-06-16 11:50:09', NULL),
	(52, NULL, 20, 1, '5', '2014-06-16 16:33:05', NULL),
	(53, NULL, 20, 1, '5', '2014-06-16 17:33:19', NULL),
	(54, NULL, 10, 1, '5', '2014-06-16 19:26:49', NULL),
	(55, NULL, 0, 1, '5', '2014-06-13 17:06:18', NULL),
	(56, NULL, 0, 1, '5', '2014-06-14 17:06:18', NULL),
	(57, NULL, 0, 1, '5', '2014-06-15 17:06:18', NULL),
	(58, NULL, 0, 1, '6', '2014-06-06 17:30:15', NULL),
	(59, NULL, 0, 1, '6', '2014-06-07 17:30:15', NULL),
	(60, NULL, 10, 1, '5', '2014-06-17 10:47:09', NULL),
	(61, NULL, 10, 1, '5', '2014-06-17 11:10:40', NULL),
	(62, NULL, 12, 1, '5', '2014-06-17 12:07:30', NULL),
	(63, NULL, 10, 1, '5', '2014-06-17 13:03:47', NULL),
	(64, NULL, 19, 1, '5', '2014-06-17 15:24:56', NULL),
	(65, NULL, 5, 1, '5', '2014-06-17 15:58:14', NULL),
	(66, NULL, 7, 1, '5', '2014-06-17 16:15:26', NULL),
	(67, NULL, 10, 1, '5', '2014-06-17 17:48:51', NULL),
	(68, NULL, 10, 1, '5', '2014-06-18 10:28:10', NULL),
	(69, NULL, 16, 1, '5', '2014-06-18 11:42:16', NULL),
	(70, NULL, 10, 1, '5', '2014-06-18 12:53:03', NULL),
	(71, NULL, 23, 1, '5', '2014-06-18 19:45:17', NULL),
	(72, NULL, 15, 1, '7', '2014-06-19 11:34:25', NULL),
	(73, NULL, 5, 1, '5', '2014-06-19 12:05:42', NULL),
	(74, NULL, 10, 1, '5', '2014-06-19 16:48:58', NULL),
	(75, NULL, 9, 1, '5', '2014-06-19 17:17:56', NULL),
	(76, 1, 27, 1, '5', '2014-06-19 17:30:37', NULL);
/*!40000 ALTER TABLE `pullups` ENABLE KEYS */;


-- Дамп структуры для таблица sport.pushups
CREATE TABLE IF NOT EXISTS `pushups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `value` int(11) DEFAULT NULL,
  `place` int(11) DEFAULT NULL,
  `fatigue` int(11) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `unixtime` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `place` (`place`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COMMENT='Отжимания';

-- Дамп данных таблицы sport.pushups: ~17 rows (приблизительно)
DELETE FROM `pushups`;
/*!40000 ALTER TABLE `pushups` DISABLE KEYS */;
INSERT INTO `pushups` (`id`, `uid`, `value`, `place`, `fatigue`, `timestamp`, `unixtime`) VALUES
	(1, 0, 20, 4, NULL, '2014-06-03 21:44:31', NULL),
	(2, 0, 0, 4, 7, '2014-06-04 19:18:46', NULL),
	(3, 0, 15, 4, 5, '2014-06-09 19:19:07', NULL),
	(4, 0, 15, 4, 5, '2014-06-09 19:27:15', NULL),
	(5, 0, 10, 4, 5, '2014-06-09 19:37:32', NULL),
	(6, 0, 20, 4, 7, '2014-06-09 19:18:46', NULL),
	(7, 0, 0, 4, 7, '2014-06-05 19:18:46', NULL),
	(8, 0, 0, 4, 7, '2014-06-06 19:18:46', NULL),
	(9, 0, 0, 4, 7, '2014-06-07 19:18:46', NULL),
	(10, 0, 0, 4, 7, '2014-06-08 19:18:46', NULL),
	(11, 0, 0, 4, 5, '2014-06-10 19:37:32', NULL),
	(12, 0, 0, 4, 5, '2014-06-11 19:37:32', NULL),
	(13, 0, 0, 4, 5, '2014-06-12 19:37:32', NULL),
	(14, 0, 0, 4, 5, '2014-06-13 19:37:32', NULL),
	(15, 0, 0, 4, 5, '2014-06-14 19:37:32', NULL),
	(16, 0, 0, 4, 5, '2014-06-15 19:37:32', NULL),
	(17, 0, 0, 4, 5, '2014-06-16 19:37:32', NULL);
/*!40000 ALTER TABLE `pushups` ENABLE KEYS */;


-- Дамп структуры для таблица sport.ration
CREATE TABLE IF NOT EXISTS `ration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `time` time DEFAULT NULL,
  `number` tinyint(4) DEFAULT NULL,
  `kkal` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `KEY` (`type`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='Дневной рацион';

-- Дамп данных таблицы sport.ration: ~27 rows (приблизительно)
DELETE FROM `ration`;
/*!40000 ALTER TABLE `ration` DISABLE KEYS */;
INSERT INTO `ration` (`id`, `uid`, `time`, `number`, `kkal`, `type`, `timestamp`) VALUES
	(8, 0, '07:00:00', 1, 500, 2, '2014-06-04 22:32:48'),
	(9, 0, '13:30:00', 2, 1500, 5, '2014-06-04 22:33:07'),
	(10, 0, '20:00:00', 3, 1000, 6, '2014-06-04 22:33:31'),
	(11, 0, '09:30:00', 1, 700, 1, '2014-06-05 10:34:31'),
	(12, 0, '14:30:00', 2, 2000, 4, '2014-06-05 16:09:11'),
	(13, 0, '12:00:00', 1, 200, 3, '2014-06-07 00:55:08'),
	(14, 0, '13:55:38', 1, 200, 3, '2014-06-08 13:55:38'),
	(15, 0, '09:30:00', 1, 200, 3, '2014-06-09 13:11:31'),
	(16, 0, '14:30:00', 2, 500, 5, '2014-06-09 15:41:31'),
	(17, 0, '20:00:00', 3, 300, 7, '2014-06-09 20:22:49'),
	(18, 0, '08:00:00', 1, 300, 2, '2014-06-10 08:51:05'),
	(19, 0, '09:20:00', 1, 300, 2, '2014-06-11 10:40:12'),
	(20, 0, '15:00:00', 2, 1500, 4, '2014-06-11 17:38:46'),
	(21, 0, '21:10:00', 3, 500, 6, '2014-06-11 22:02:00'),
	(22, 0, '09:00:00', 1, 400, 1, '2014-06-12 10:29:51'),
	(23, 0, '14:00:00', 2, 1000, 4, '2014-06-12 14:37:24'),
	(24, 0, '09:00:00', 1, 100, 3, '2014-06-16 11:12:08'),
	(25, 0, '12:05:23', 2, 200, 8, '2014-06-16 12:05:23'),
	(26, 0, '14:30:00', 3, 1000, 4, '2014-06-16 15:07:31'),
	(27, 0, '09:00:00', 1, 300, 2, '2014-06-17 10:47:36'),
	(28, 0, '13:30:00', 2, 1000, 4, '2014-06-17 15:10:44'),
	(29, 0, '20:00:00', 3, 200, 7, '2014-06-17 22:08:54'),
	(30, 0, '09:00:00', 1, 200, 1, '2014-06-18 12:36:07'),
	(31, 0, '14:00:00', 2, 1000, 4, '2014-06-18 16:01:17'),
	(32, 0, '20:00:00', 1, 500, 6, '2014-06-18 00:29:53'),
	(33, 0, '10:30:00', 1, 300, 2, '2014-06-19 11:37:45'),
	(34, 0, '15:00:00', 2, 1000, 4, '2014-06-19 15:41:50');
/*!40000 ALTER TABLE `ration` ENABLE KEYS */;


-- Дамп структуры для таблица sport.ration_types
CREATE TABLE IF NOT EXISTS `ration_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `mark` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Типы приема пищи';

-- Дамп данных таблицы sport.ration_types: ~8 rows (приблизительно)
DELETE FROM `ration_types`;
/*!40000 ALTER TABLE `ration_types` DISABLE KEYS */;
INSERT INTO `ration_types` (`id`, `value`, `mark`) VALUES
	(1, 'Полноценный завтрак', 10),
	(2, 'Быстрый завтрак', 5),
	(3, 'Чай-завтрак', 1),
	(4, 'Полноценный обед', 10),
	(5, 'Обед без первого', 7),
	(6, 'Полноценный ужин', 10),
	(7, 'Быстрый ужин', 5),
	(8, 'Перекус', 3);
/*!40000 ALTER TABLE `ration_types` ENABLE KEYS */;


-- Дамп структуры для таблица sport.running
CREATE TABLE IF NOT EXISTS `running` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `distance` int(11) NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  `fatigue` int(11) NOT NULL DEFAULT '0',
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `unixtime` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы sport.running: ~0 rows (приблизительно)
DELETE FROM `running`;
/*!40000 ALTER TABLE `running` DISABLE KEYS */;
/*!40000 ALTER TABLE `running` ENABLE KEYS */;


-- Дамп структуры для таблица sport.summer
CREATE TABLE IF NOT EXISTS `summer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `serial_number` int(11) DEFAULT NULL,
  `name` text,
  `anounce` text,
  `detail_info` text,
  `photo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='Летние выходные\r\n';

-- Дамп данных таблицы sport.summer: ~13 rows (приблизительно)
DELETE FROM `summer`;
/*!40000 ALTER TABLE `summer` DISABLE KEYS */;
INSERT INTO `summer` (`id`, `uid`, `serial_number`, `name`, `anounce`, `detail_info`, `photo`) VALUES
	(1, 0, 1, 'Первые выходные лета!', 'Эти выходные я уже не помню как прошли. Может Настюха чего вспомнит. \r\nНо главное то, что таких не должно быть выходных этим летом больше! Каждые выходные должны быть насыщенны чем-либо. Так я с Настюхой проведу отличное лето и нельзя будет сказать что оно пролетело!', '<h1><span style="font-family:comic sans ms,cursive">Hello! I&#39;m first weekends!</span><br />\r\n<img alt="Saturn V carrying Apollo 11" class="right" src="http://www.kaliteliresimler.com/data/media/58/gunes_isigi_ve_agac.jpg" style="height:188px; width:250px" /></h1>', '1.jpeg'),
	(2, 0, 2, 'Выходные в четверг', 'Все началось как всегда внезапно. В четверг.  С бутылки коньяку. И понеслаааась!', '<p>Было круто, не смотря на то, что в четверг ничего не помню. Настюха говорит что мы поругались, но я не помню этого.<br />\r\nА в пятницу мы пили пивко сидя на большой карте Евпропы и думал как что будет в нашей поездке.<br />\r\nНастюха: &quot;Мне нужен фотик!&quot;))<br />\r\n<br />\r\nА потом приехал Патрик, потом Радик, потом Буллет и начался зеленый трэш. Особенно когда на след день еще Сипа приехал.<br />\r\nА ночью в Парке Челюскинцев были очень крутые соловьи! Часа в 4 утра! Я был на борде а Патрик на велике, но он сука пробил колесо!)</p>\r\n\r\n<p>А в воскресенье мы с Настюхой охеренно просто валялись и смарели фильмы) И было очень круто)</p>', NULL),
	(3, 0, 3, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', '<p>Переезд отменен на время! Хозяйка оказалась наглой сучкой, которая попросила остаться нас Ну нам и лучше, чего уж там)<br />\r\nВ субботу приезжают родители чтобы провести время с родителями Оли. Вечером будет ужин.</p>', NULL),
	(4, 0, 4, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(5, 0, 5, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(6, 0, 6, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', '<p>ДР моего отца еще тута) Сразу запишу дабы не забыть)</p>', NULL),
	(7, 0, 7, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(8, 0, 8, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(9, 0, 9, 'Открытие месяца путешествия!', 'В этим выходные открывается месяц путешествия! Всем быть готовым к новым впечатлениям и настроится на исключительно хорошее настроение!', NULL, NULL),
	(10, 0, 10, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(11, 0, 11, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(12, 0, 12, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL),
	(13, 0, 13, 'Назови меня по имени, детка', 'Опиши меня так чтобы тебе было приятно вспоминать меня всегда', NULL, NULL);
/*!40000 ALTER TABLE `summer` ENABLE KEYS */;


-- Дамп структуры для таблица sport.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `salt` varchar(255) NOT NULL DEFAULT '',
  `roles` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '',
  `time_created` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы sport.users: ~1 rows (приблизительно)
DELETE FROM `users`;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `email`, `password`, `salt`, `roles`, `name`, `time_created`) VALUES
	(1, 'engineer.morozov@gmail.com', 'S3WqD8E7bf/k6eQwBBoILugREa9+wsO3J7epIMn32zxb0eHqwSuaKrJSrigxIWM7K63mgoCVWHwpPH3XZ6E8qg==', 'ont6z0vsqlw8884kokc4o0k008s4c04', 'ROLE_USER,ROLE_ADMIN', 'roman', 1403013545);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;


-- Дамп структуры для таблица sport.water_ration
CREATE TABLE IF NOT EXISTS `water_ration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `time` time DEFAULT NULL COMMENT 'Время, когда попил',
  `type` int(11) DEFAULT '1' COMMENT 'Какая жидкость',
  `value` int(11) DEFAULT '200' COMMENT 'Объем в милиллитрах',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='Прием воды';

-- Дамп данных таблицы sport.water_ration: ~41 rows (приблизительно)
DELETE FROM `water_ration`;
/*!40000 ALTER TABLE `water_ration` DISABLE KEYS */;
INSERT INTO `water_ration` (`id`, `uid`, `time`, `type`, `value`, `timestamp`) VALUES
	(1, 0, '22:55:21', 1, 200, '2014-06-04 22:55:21'),
	(2, 0, '20:30:00', 3, 200, '2014-06-04 22:56:25'),
	(3, 0, '10:32:49', 1, 150, '2014-06-05 10:32:49'),
	(4, 0, '09:30:00', 3, 200, '2014-06-05 10:33:09'),
	(5, 0, '12:45:58', 3, 150, '2014-06-05 12:45:58'),
	(6, 0, '13:46:26', 3, 200, '2014-06-05 13:46:26'),
	(7, 0, '14:30:00', 2, 200, '2014-06-05 16:09:54'),
	(8, 0, '16:57:27', 1, 500, '2014-06-05 16:57:27'),
	(9, 0, '09:30:00', 3, 200, '2014-06-09 13:13:06'),
	(10, 0, '15:25:33', 3, 200, '2014-06-09 15:25:33'),
	(11, 0, '15:25:40', 3, 200, '2014-06-09 15:25:40'),
	(12, 0, '18:33:33', 3, 200, '2014-06-09 18:33:33'),
	(13, 0, '08:00:00', 3, 200, '2014-06-10 09:59:31'),
	(14, 0, '17:19:16', 3, 500, '2014-06-10 17:19:16'),
	(15, 0, '14:00:00', 1, 200, '2014-06-10 17:19:26'),
	(16, 0, '09:20:00', 3, 250, '2014-06-11 10:40:39'),
	(17, 0, '09:00:00', 1, 200, '2014-06-11 10:40:49'),
	(18, 0, '10:40:57', 3, 250, '2014-06-11 10:40:57'),
	(19, 0, '15:00:00', 2, 200, '2014-06-11 17:39:11'),
	(20, 0, '18:17:52', 3, 250, '2014-06-11 18:17:52'),
	(21, 0, '22:02:14', 1, 250, '2014-06-11 22:02:14'),
	(22, 0, '09:00:00', 3, 250, '2014-06-12 10:30:11'),
	(23, 0, '12:39:10', 1, 250, '2014-06-12 12:39:10'),
	(24, 0, '14:00:00', 2, 200, '2014-06-12 14:37:50'),
	(25, 0, '17:27:52', 1, 250, '2014-06-12 17:27:52'),
	(26, 0, '09:00:00', 3, 250, '2014-06-16 11:12:20'),
	(27, 0, '16:00:00', 4, 150, '2014-06-16 22:36:28'),
	(28, 0, '22:36:37', 1, 400, '2014-06-16 22:36:37'),
	(29, 0, '10:47:50', 3, 200, '2014-06-17 10:47:50'),
	(30, 0, '13:45:00', 1, 500, '2014-06-17 15:11:04'),
	(31, 0, '15:16:57', 1, 500, '2014-06-17 15:16:57'),
	(32, 0, '20:00:00', 3, 250, '2014-06-17 22:09:10'),
	(33, 0, '22:09:27', 1, 500, '2014-06-17 22:09:27'),
	(34, 0, '09:00:00', 3, 250, '2014-06-18 12:36:18'),
	(35, 0, '12:36:26', 3, 500, '2014-06-18 12:36:26'),
	(36, 0, '14:00:00', 2, 250, '2014-06-18 16:01:32'),
	(37, 0, '19:46:03', 1, 250, '2014-06-18 19:46:03'),
	(38, 0, '11:00:00', 3, 250, '2014-06-19 11:38:03'),
	(39, 0, '11:38:13', 1, 250, '2014-06-19 11:38:13'),
	(40, 0, '12:55:51', 1, 250, '2014-06-19 12:55:51'),
	(41, 0, '15:46:04', 7, 250, '2014-06-19 15:46:04');
/*!40000 ALTER TABLE `water_ration` ENABLE KEYS */;


-- Дамп структуры для таблица sport.water_types
CREATE TABLE IF NOT EXISTS `water_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `kkal` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='Виды приема воды\r\n';

-- Дамп данных таблицы sport.water_types: ~8 rows (приблизительно)
DELETE FROM `water_types`;
/*!40000 ALTER TABLE `water_types` DISABLE KEYS */;
INSERT INTO `water_types` (`id`, `value`, `kkal`) VALUES
	(1, 'Вода', 0),
	(2, 'Сок', 0),
	(3, 'Чай', 0),
	(4, 'Кофе', 0),
	(5, 'Газировка сладкая', 0),
	(6, 'Минералка', 0),
	(7, 'Компот', 0),
	(8, 'Кисель', 0);
/*!40000 ALTER TABLE `water_types` ENABLE KEYS */;


-- Дамп структуры для таблица sport.weather
CREATE TABLE IF NOT EXISTS `weather` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) NOT NULL DEFAULT '0',
  `mark` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Состояния погоды';

-- Дамп данных таблицы sport.weather: ~5 rows (приблизительно)
DELETE FROM `weather`;
/*!40000 ALTER TABLE `weather` DISABLE KEYS */;
INSERT INTO `weather` (`id`, `value`, `mark`) VALUES
	(1, 'Солнечно и жарко', 50),
	(3, 'Душно', 50),
	(4, 'Пасмурно', 30),
	(5, 'Дождь', 0),
	(6, 'Солнечно, но холодоно', 0);
/*!40000 ALTER TABLE `weather` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
