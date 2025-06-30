-- Patient information
CREATE TABLE `patients` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `sex` ENUM('M', 'F', 'Other') DEFAULT NULL,
    `age` INT DEFAULT NULL,
    `outcome` ENUM('Complete Response', 'Partial Response', 'Progression'),
    `trial_id` INT,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`trial_id`) REFERENCES `trials`(`id`)
);

-- Clinical trial information
CREATE TABLE `trials` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `phase` ENUM('I', 'II', 'III', 'IV'),
    `status` ENUM('Active', 'Completed', 'Suspended', 'Withdrawn'),
    `start_date` DATE,
    `end_date` DATE,
    PRIMARY KEY (`id`)
);

-- Drug information
CREATE TABLE `drugs` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `type` VARCHAR(255) NOT NULL,       -- e.g., monoclonal antibody (mAb), tyrosine kinase inhibitor (TKI)
    `target` VARCHAR(255) NOT NULL,     -- e.g., PD-1, HER-2
    PRIMARY KEY (`id`)
);

-- Type of cancer information
CREATE TABLE `cancers` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,       -- e.g., breast, prostate, lung
    PRIMARY KEY (`id`)
);

-- Join table for many-to-many relationship between trials and drugs
CREATE TABLE `trial_drugs` (
    `trial_id` INT NOT NULL,
    `drug_id` INT NOT NULL,
    PRIMARY KEY (`trial_id`, `drug_id`),
    FOREIGN KEY (`trial_id`) REFERENCES `trials`(`id`),
    FOREIGN KEY (`drug_id`) REFERENCES `drugs`(`id`)
);

-- Join table for many-to-many relationship between trials and cancer types
CREATE TABLE `trial_cancers` (
    `trial_id` INT NOT NULL,
    `cancer_id` INT NOT NULL,
    PRIMARY KEY (`trial_id`, `cancer_id`),
    FOREIGN KEY (`trial_id`) REFERENCES `trials`(`id`),
    FOREIGN KEY (`cancer_id`) REFERENCES `cancers`(`id`)
);

-- Join table for many-to-many relationship between patients and cancer types
CREATE TABLE `patient_cancers` (
    `patient_id` INT NOT NULL,
    `cancer_id` INT NOT NULL,
    PRIMARY KEY (`patient_id`, `cancer_id`),
    FOREIGN KEY (`patient_id`) REFERENCES `patients`(`id`),
    FOREIGN KEY (`cancer_id`) REFERENCES `cancers`(`id`)
);

-- Indexes for join table search optimisation
CREATE INDEX `search_all_drugs_in_a_trial` ON `trial_drugs`(`trial_id`);
CREATE INDEX `search_all_trials_using_a_drug` ON `trial_drugs`(`drug_id`);
CREATE INDEX `search_all_cancers_in_a_trial` ON `trial_cancers`(`trial_id`);
CREATE INDEX `search_all_trials_for_a_cancer` ON `trial_cancers`(`cancer_id`);
CREATE INDEX `search_all_cancers_for_a_patient` ON `patient_cancers`(`cancer_id`);
