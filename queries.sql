-- View the name, phase and status of all clinical trials
SELECT `id`, `name`, `phase`, `status`
FROM `trials`;

-- View the patient information for the trials they are enrolled in
SELECT `patients`.`id` AS `patient_id`, `patients`.`sex`, `patients`.`age`, `patients`.`outcome`, `trials`.`name` AS `Trial Name`
FROM `patients`
JOIN `trials` ON `patients`.`trial_id` = `trials`.`id`;

-- View the number of patients enrolled in each trial
SELECT `trials`.`name` AS `trial_name`, COUNT(`patients`.`id`) AS `Patient Count`
FROM `trials`
LEFT JOIN `patients` ON `patients`.`trial_id` = `trials`.`id`
GROUP BY `trials`.`id`, `trials`.`name`;

-- View all drugs used in a particular trial (e.g. clinical trial ID 6)
SELECT `drugs`.`name` AS `Drug Name`, `drugs`.`type`, `drugs`.`target`
FROM `drugs`
JOIN `trial_drugs` ON `drugs`.`id` = `trial_drugs`.`drug_id`
WHERE `trial_drugs`.`trial_id` = 6;

-- View all trials using a particular drug (e.g. Nivolumab; case-insensitive)
SELECT `trials`.`name` AS `Trial Name`, `trials`.`phase`, `trials`.`status`
FROM `trials`
JOIN `trial_drugs` ON `trials`.`id` = `trial_drugs`.`trial_id`
JOIN `drugs` ON `drugs`.`id` = `trial_drugs`.`drug_id`
WHERE LOWER(`drugs`.`name`) = 'nivolumab';

-- View all clinical trials that started in 2020
SELECT `name`, `phase`, `start_date`
FROM `trials`
WHERE YEAR(`start_date`) = 2020;

-- View all patients who achieved a Complete Response and the drug treatment they took
SELECT `patients`.`id` AS `Patient ID`, `patients`.`sex`, `patients`.`age`, `drugs`.`name` AS `Drug Name`
FROM `patients`
JOIN `trial_drugs` ON `patients`.`trial_id` = `trial_drugs`.`trial_id`
JOIN `drugs` ON `drugs`.`id` = `trial_drugs`.`drug_id`
WHERE `patients`.`outcome` = 'Complete Response'
ORDER BY `patients`.`age` DESC;

-- View all trials that target prostate cancer
SELECT `trials`.`name` AS `Trial Name`, `trials`.`phase`, `trials`.`status`
FROM `trials`
JOIN `trial_cancers` ON `trials`.`id` = `trial_cancers`.`trial_id`
JOIN `cancers` ON `cancers`.`id` = `trial_cancers`.`cancer_id`
WHERE `cancers`.`name` = 'prostate';

-- Insert data for a new patient enrolled in a specific trial
INSERT INTO `patients` (`sex`, `age`, `outcome`, `trial_id`)
VALUES ('F', 58, 'Complete Response',
    (SELECT `id` FROM `trials` WHERE UPPER(`name`) = 'KEYNOTE-001'));

-- Update outcome data for a patient
UPDATE `patients`
SET `outcome` = 'Progression'
WHERE `id` = 133;
