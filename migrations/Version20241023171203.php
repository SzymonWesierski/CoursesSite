<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20241023171203 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__chapter AS SELECT id, courses_id, name FROM chapter');
        $this->addSql('DROP TABLE chapter');
        $this->addSql('CREATE TABLE chapter (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, course_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, CONSTRAINT FK_F981B52E591CC992 FOREIGN KEY (course_id) REFERENCES course (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO chapter (id, course_id, name) SELECT id, courses_id, name FROM __temp__chapter');
        $this->addSql('DROP TABLE __temp__chapter');
        $this->addSql('CREATE INDEX IDX_F981B52E591CC992 ON chapter (course_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__chapter AS SELECT id, course_id, name FROM chapter');
        $this->addSql('DROP TABLE chapter');
        $this->addSql('CREATE TABLE chapter (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, courses_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, CONSTRAINT FK_F981B52EF9295384 FOREIGN KEY (courses_id) REFERENCES course (id) ON UPDATE NO ACTION ON DELETE NO ACTION NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO chapter (id, courses_id, name) SELECT id, course_id, name FROM __temp__chapter');
        $this->addSql('DROP TABLE __temp__chapter');
        $this->addSql('CREATE INDEX IDX_F981B52EF9295384 ON chapter (courses_id)');
    }
}
