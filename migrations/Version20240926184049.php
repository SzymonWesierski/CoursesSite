<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20240926184049 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE episode ADD COLUMN public_image_id VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE episode ADD COLUMN public_video_id VARCHAR(255) DEFAULT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__episode AS SELECT id, chapter_id, name, description, video_path, image_path FROM episode');
        $this->addSql('DROP TABLE episode');
        $this->addSql('CREATE TABLE episode (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, chapter_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) DEFAULT NULL, video_path VARCHAR(255) DEFAULT NULL, image_path VARCHAR(255) DEFAULT NULL, CONSTRAINT FK_DDAA1CDA579F4768 FOREIGN KEY (chapter_id) REFERENCES chapter (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO episode (id, chapter_id, name, description, video_path, image_path) SELECT id, chapter_id, name, description, video_path, image_path FROM __temp__episode');
        $this->addSql('DROP TABLE __temp__episode');
        $this->addSql('CREATE INDEX IDX_DDAA1CDA579F4768 ON episode (chapter_id)');
    }
}
