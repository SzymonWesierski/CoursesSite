<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250109203452 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE course_draft DROP CONSTRAINT fk_afd7917c75ab8617');
        $this->addSql('DROP INDEX uniq_afd7917c75ab8617');
        $this->addSql('ALTER TABLE course_draft RENAME COLUMN course_draft_temp_id TO course_draft_to_be_checked_id');
        $this->addSql('ALTER TABLE course_draft ADD CONSTRAINT FK_AFD7917C5B05A6B9 FOREIGN KEY (course_draft_to_be_checked_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_AFD7917C5B05A6B9 ON course_draft (course_draft_to_be_checked_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE course_draft DROP CONSTRAINT FK_AFD7917C5B05A6B9');
        $this->addSql('DROP INDEX UNIQ_AFD7917C5B05A6B9');
        $this->addSql('ALTER TABLE course_draft RENAME COLUMN course_draft_to_be_checked_id TO course_draft_temp_id');
        $this->addSql('ALTER TABLE course_draft ADD CONSTRAINT fk_afd7917c75ab8617 FOREIGN KEY (course_draft_temp_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX uniq_afd7917c75ab8617 ON course_draft (course_draft_temp_id)');
    }
}
