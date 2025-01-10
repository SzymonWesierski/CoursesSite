<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250109222553 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE course_draft DROP CONSTRAINT fk_afd7917c5b05a6b9');
        $this->addSql('DROP INDEX uniq_afd7917c5b05a6b9');
        $this->addSql('ALTER TABLE course_draft RENAME COLUMN course_draft_to_be_checked_id TO related_course_draft_for_approval_id');
        $this->addSql('ALTER TABLE course_draft ADD CONSTRAINT FK_AFD7917C46747BF3 FOREIGN KEY (related_course_draft_for_approval_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_AFD7917C46747BF3 ON course_draft (related_course_draft_for_approval_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE SCHEMA public');
        $this->addSql('ALTER TABLE course_draft DROP CONSTRAINT FK_AFD7917C46747BF3');
        $this->addSql('DROP INDEX UNIQ_AFD7917C46747BF3');
        $this->addSql('ALTER TABLE course_draft RENAME COLUMN related_course_draft_for_approval_id TO course_draft_to_be_checked_id');
        $this->addSql('ALTER TABLE course_draft ADD CONSTRAINT fk_afd7917c5b05a6b9 FOREIGN KEY (course_draft_to_be_checked_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE');
        $this->addSql('CREATE UNIQUE INDEX uniq_afd7917c5b05a6b9 ON course_draft (course_draft_to_be_checked_id)');
    }
}
