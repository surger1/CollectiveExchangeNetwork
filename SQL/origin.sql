CREATE TABLE Organization (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  website VARCHAR(255),
  contact_email VARCHAR(255)
);

CREATE TABLE Project (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE Resource (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  type ENUM('MATERIAL', 'EQUIPMENT', 'SKILL', 'OTHER')
);

CREATE TABLE User (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE Role (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE Permission (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE Task (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  start_date DATE,
  end_date DATE,
  status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'ON_HOLD'),
  FOREIGN KEY (project_id) REFERENCES Project(id)
);

CREATE TABLE Service (
  id INT AUTO_INCREMENT PRIMARY KEY,
  organization_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE Event (
  id INT AUTO_INCREMENT PRIMARY KEY,
  organization_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  start_date_time DATETIME,
  end_date_time DATETIME,
  location VARCHAR(255),
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE Schedule (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  event_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES User(id),
  FOREIGN KEY (event_id) REFERENCES Event(id)
);

CREATE TABLE Comment (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  parent_id INT,
  FOREIGN KEY (user_id) REFERENCES User(id),
  FOREIGN KEY (parent_id) REFERENCES Comment(id)
);

CREATE TABLE Tag (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE Priority (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  level INT NOT NULL
);

CREATE TABLE Physical_Location (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  country VARCHAR(255),
  postal_code VARCHAR(255),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8)
);

CREATE TABLE Virtual_Location (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  application VARCHAR(255),
  sub_address VARCHAR(255),
);

CREATE TABLE Location (
  id INT AUTO_INCREMENT PRIMARY KEY,
  location_type ENUM('physical', 'virtual') NOT NULL,
  physical_location_id INT,
  virtual_location_id INT,
  FOREIGN KEY (physical_location_id) REFERENCES Physical_Location(id),
  FOREIGN KEY (virtual_location_id) REFERENCES Virtual_Location(id)
);

CREATE TABLE Rule (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE Transaction (
  id INT AUTO_INCREMENT PRIMARY KEY,
  initiator_user_id INT,
  initiator_role_id INT,
  initiator_organization_id INT,
  receiver_user_id INT,
  receiver_role_id INT,
  receiver_organization_id INT,
  date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pending', 'completed', 'disputed') NOT NULL DEFAULT 'pending',
  FOREIGN KEY (initiator_user_id) REFERENCES User(id),
  FOREIGN KEY (initiator_role_id) REFERENCES Role(id),
  FOREIGN KEY (initiator_organization_id) REFERENCES Organization(id),
  FOREIGN KEY (receiver_user_id) REFERENCES User(id),
  FOREIGN KEY (receiver_role_id) REFERENCES Role(id),
  FOREIGN KEY (receiver_organization_id) REFERENCES Organization(id)
);


CREATE TABLE Password (
  id INT AUTO_INCREMENT PRIMARY KEY,
  password_hash VARCHAR(255) NOT NULL,
  date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE Rating (
  id INT AUTO_INCREMENT PRIMARY KEY,
  score INT NOT NULL,
  date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  -- Add any other relevant columns
);

CREATE TABLE Role_Organization (
  role_id INT NOT NULL,
  organization_id INT NOT NULL,
  PRIMARY KEY (role_id, organization_id),
  FOREIGN KEY (role_id) REFERENCES Role(id),
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE Role_Project (
  role_id INT NOT NULL,
  project_id INT NOT NULL,
  PRIMARY KEY (role_id, project_id),
  FOREIGN KEY (role_id) REFERENCES Role(id),
  FOREIGN KEY (project_id) REFERENCES Project(id)
);

CREATE TABLE Project_Organization (
  project_id INT NOT NULL,
  organization_id INT NOT NULL,
  PRIMARY KEY (project_id, organization_id),
  FOREIGN KEY (project_id) REFERENCES Project(id),
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE User_Role (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (user_id) REFERENCES User(id),
  FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE Event_Schedule (
  event_id INT NOT NULL,
  schedule_id INT NOT NULL,
  PRIMARY KEY (event_id, schedule_id),
  FOREIGN KEY (event_id) REFERENCES Event(id),
  FOREIGN KEY (schedule_id) REFERENCES Schedule(id)
);

CREATE TABLE Service_Schedule (
  service_id INT NOT NULL,
  schedule_id INT NOT NULL,
  PRIMARY KEY (service_id, schedule_id),
  FOREIGN KEY (service_id) REFERENCES Service(id),
  FOREIGN KEY (schedule_id) REFERENCES Schedule(id)
);

CREATE TABLE Resource_Schedule (
  resource_id INT NOT NULL,
  schedule_id INT NOT NULL,
  PRIMARY KEY (resource_id, schedule_id),
  FOREIGN KEY (resource_id) REFERENCES Resource(id),
  FOREIGN KEY (schedule_id) REFERENCES Schedule(id)
);

CREATE TABLE Task_Schedule (
  task_id INT NOT NULL,
  schedule_id INT NOT NULL,
  PRIMARY KEY (task_id, schedule_id),
  FOREIGN KEY (task_id) REFERENCES Task(id),
  FOREIGN KEY (schedule_id) REFERENCES Schedule(id)
);

CREATE TABLE Task_Resource (
  task_id INT NOT NULL,
  resource_id INT NOT NULL,
  PRIMARY KEY (task_id, resource_id),
  FOREIGN KEY (task_id) REFERENCES Task(id),
  FOREIGN KEY (resource_id) REFERENCES Resource(id)
);

CREATE TABLE Event_Permission (
  event_id INT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (event_id, permission_id),
  FOREIGN KEY (event_id) REFERENCES Event(id),
  FOREIGN KEY (permission_id) REFERENCES Permission(id)
);

CREATE TABLE Tag_Organization (
  tag_id INT NOT NULL,
  organization_id INT NOT NULL,
  PRIMARY KEY (tag_id, organization_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE Tag_Project (
  tag_id INT NOT NULL,
  project_id INT NOT NULL,
  PRIMARY KEY (tag_id, project_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (project_id) REFERENCES Project(id)
);

CREATE TABLE Tag_Role (
  tag_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (tag_id, role_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE Tag_Task (
  tag_id INT NOT NULL,
  task_id INT NOT NULL,
  PRIMARY KEY (tag_id, task_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (task_id) REFERENCES Task(id)
);

CREATE TABLE Tag_Service (
  tag_id INT NOT NULL,
  service_id INT NOT NULL,
  PRIMARY KEY (tag_id, service_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (service_id) REFERENCES Service(id)
);

CREATE TABLE Tag_Event (
  tag_id INT NOT NULL,
  event_id INT NOT NULL,
  PRIMARY KEY (tag_id, event_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (event_id) REFERENCES Event(id)
);

CREATE TABLE Tag_Comment (
  tag_id INT NOT NULL,
  comment_id INT NOT NULL,
  PRIMARY KEY (tag_id, comment_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id)
);

CREATE TABLE Tag_Location (
  tag_id INT NOT NULL,
  location_id INT NOT NULL,
  PRIMARY KEY (tag_id, location_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (location_id) REFERENCES Location(id)
);

CREATE TABLE Tag_Rule (
  tag_id INT NOT NULL,
  rule_id INT NOT NULL,
  PRIMARY KEY (tag_id, rule_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (rule_id) REFERENCES Rule(id)
);

CREATE TABLE Tag_Resource (
  tag_id INT NOT NULL,
  resource_id INT NOT NULL,
  PRIMARY KEY (tag_id, resource_id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id),
  FOREIGN KEY (resource_id) REFERENCES Resource(id)
);

CREATE TABLE Comment_Organization (
  comment_id INT NOT NULL,
  organization_id INT NOT NULL,
  PRIMARY KEY (comment_id, organization_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (organization_id) REFERENCES Organization(id)
);

CREATE TABLE Comment_Project (
  comment_id INT NOT NULL,
  project_id INT NOT NULL,
  PRIMARY KEY (comment_id, project_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (project_id) REFERENCES Project(id)
);

CREATE TABLE Comment_Task (
  comment_id INT NOT NULL,
  task_id INT NOT NULL,
  PRIMARY KEY (comment_id, task_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (task_id) REFERENCES Task(id)
);

CREATE TABLE Comment_Role (
  comment_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (comment_id, role_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (role_id) REFERENCES Role(id)
);

CREATE TABLE Comment_Resource (
  comment_id INT NOT NULL,
  resource_id INT NOT NULL,
  PRIMARY KEY (comment_id, resource_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (resource_id) REFERENCES Resource(id)
);

CREATE TABLE Comment_Service (
  comment_id INT NOT NULL,
  service_id INT NOT NULL,
  PRIMARY KEY (comment_id, service_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (service_id) REFERENCES Service(id)
);

CREATE TABLE Comment_Tag (
  comment_id INT NOT NULL,
  tag_id INT NOT NULL,
  PRIMARY KEY (comment_id, tag_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

CREATE TABLE Comment_Priority (
  comment_id INT NOT NULL,
  priority_id INT NOT NULL,
  PRIMARY KEY (comment_id, priority_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (priority_id) REFERENCES Priority(id)
);

CREATE TABLE Comment_Location (
  comment_id INT NOT NULL,
  location_id INT NOT NULL,
  PRIMARY KEY (comment_id, location_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (location_id) REFERENCES Location(id)
);

CREATE TABLE Comment_Rule (
  comment_id INT NOT NULL,
  rule_id INT NOT NULL,
  PRIMARY KEY (comment_id, rule_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (rule_id) REFERENCES Rule(id)
);

CREATE TABLE Comment_Comment (
  comment_id INT NOT NULL,
  parent_comment_id INT NOT NULL,
  PRIMARY KEY (comment_id, parent_comment_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (parent_comment_id) REFERENCES Comment(id)
);

CREATE TABLE Service_Rating (
  service_id INT NOT NULL,
  rating_id INT NOT NULL,
  PRIMARY KEY (service_id, rating_id),
  FOREIGN KEY (service_id) REFERENCES Service(id),
  FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

CREATE TABLE Resource_Rating (
  resource_id INT NOT NULL,
  rating_id INT NOT NULL,
  PRIMARY KEY (resource_id, rating_id),
  FOREIGN KEY (resource_id) REFERENCES Resource(id),
  FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

CREATE TABLE Comment_Rating (
  comment_id INT NOT NULL,
  rating_id INT NOT NULL,
  PRIMARY KEY (comment_id, rating_id),
  FOREIGN KEY (comment_id) REFERENCES Comment(id),
  FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

CREATE TABLE Transaction_Rating (
  transaction_id INT NOT NULL,
  rating_id INT NOT NULL,
  PRIMARY KEY (transaction_id, rating_id),
  FOREIGN KEY (transaction_id) REFERENCES Transaction(id),
  FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

CREATE TABLE Event_Rating (
  event_id INT NOT NULL,
  rating_id INT NOT NULL,
  PRIMARY KEY (event_id, rating_id),
  FOREIGN KEY (event_id) REFERENCES Event(id),
  FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

CREATE TABLE Location_Rating (
  location_id INT NOT NULL,
  rating_id INT NOT NULL,
  PRIMARY KEY (location_id, rating_id),
  FOREIGN KEY (location_id) REFERENCES Location(id),
  FOREIGN KEY (rating_id) REFERENCES Rating(id)
);

