<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20241211174312 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN name VARCHAR(255) NOT NULL');
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN description VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN video_path VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN image_path VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN public_image_id VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN public_video_id VARCHAR(255) DEFAULT NULL');
        $this->addSql('ALTER TABLE episode_draft ADD COLUMN is_free_to_watch BOOLEAN NOT NULL');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__episode_draft AS SELECT id, chapter_draft_id FROM episode_draft');
        $this->addSql('DROP TABLE episode_draft');
        $this->addSql('CREATE TABLE episode_draft (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, chapter_draft_id INTEGER DEFAULT NULL, CONSTRAINT FK_7D7660C04EAA8D4 FOREIGN KEY (chapter_draft_id) REFERENCES chapter_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO episode_draft (id, chapter_draft_id) SELECT id, chapter_draft_id FROM __temp__episode_draft');
        $this->addSql('DROP TABLE __temp__episode_draft');
        $this->addSql('CREATE INDEX IDX_7D7660C04EAA8D4 ON episode_draft (chapter_draft_id)');
    }
}
