<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240925194550 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE course ADD COLUMN public_image_id VARCHAR(255) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__course AS SELECT id, user_id, name, description, image_path, status FROM course');
        $this->addSql('DROP TABLE course');
        $this->addSql('CREATE TABLE course (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) NOT NULL, image_path VARCHAR(255) DEFAULT NULL, status VARCHAR(64) NOT NULL, CONSTRAINT FK_169E6FB9A76ED395 FOREIGN KEY (user_id) REFERENCES user (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO course (id, user_id, name, description, image_path, status) SELECT id, user_id, name, description, image_path, status FROM __temp__course');
        $this->addSql('DROP TABLE __temp__course');
        $this->addSql('CREATE INDEX IDX_169E6FB9A76ED395 ON course (user_id)');
    }
}
