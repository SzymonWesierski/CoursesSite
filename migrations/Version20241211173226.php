<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20241211173226 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TABLE cart (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id INTEGER NOT NULL, amount_of_products INTEGER DEFAULT NULL, purchased BOOLEAN DEFAULT NULL, purchased_at DATETIME DEFAULT NULL --(DC2Type:datetime_immutable)
        , total_value DOUBLE PRECISION NOT NULL, CONSTRAINT FK_BA388B7A76ED395 FOREIGN KEY (user_id) REFERENCES user (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_BA388B7A76ED395 ON cart (user_id)');
        $this->addSql('CREATE TABLE cart_course (cart_id INTEGER NOT NULL, course_id CHAR(36) NOT NULL --(DC2Type:uuid)
        , PRIMARY KEY(cart_id, course_id), CONSTRAINT FK_181A0DE61AD5CDBF FOREIGN KEY (cart_id) REFERENCES cart (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT FK_181A0DE6591CC992 FOREIGN KEY (course_id) REFERENCES course (id) ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_181A0DE61AD5CDBF ON cart_course (cart_id)');
        $this->addSql('CREATE INDEX IDX_181A0DE6591CC992 ON cart_course (course_id)');
        $this->addSql('CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, parent_id INTEGER DEFAULT NULL, name VARCHAR(255) NOT NULL, CONSTRAINT FK_64C19C1727ACA70 FOREIGN KEY (parent_id) REFERENCES category (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_64C19C1727ACA70 ON category (parent_id)');
        $this->addSql('CREATE TABLE chapter (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, course_id CHAR(36) NOT NULL --(DC2Type:uuid)
        , name VARCHAR(255) NOT NULL, CONSTRAINT FK_F981B52E591CC992 FOREIGN KEY (course_id) REFERENCES course (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_F981B52E591CC992 ON chapter (course_id)');
        $this->addSql('CREATE TABLE chapter_draft (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, course_draft_id CHAR(36) DEFAULT NULL --(DC2Type:uuid)
        , name VARCHAR(255) NOT NULL, CONSTRAINT FK_C635002B4B47A887 FOREIGN KEY (course_draft_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_C635002B4B47A887 ON chapter_draft (course_draft_id)');
        $this->addSql('CREATE TABLE course (id CHAR(36) NOT NULL --(DC2Type:uuid)
        , course_draft_id CHAR(36) NOT NULL --(DC2Type:uuid)
        , user_id INTEGER NOT NULL, category_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) NOT NULL, image_path VARCHAR(255) DEFAULT NULL, status VARCHAR(64) NOT NULL, public_image_id VARCHAR(255) DEFAULT NULL, price DOUBLE PRECISION DEFAULT NULL, rating_average DOUBLE PRECISION NOT NULL, PRIMARY KEY(id), CONSTRAINT FK_169E6FB94B47A887 FOREIGN KEY (course_draft_id) REFERENCES course_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT FK_169E6FB9A76ED395 FOREIGN KEY (user_id) REFERENCES user (id) NOT DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT FK_169E6FB912469DE2 FOREIGN KEY (category_id) REFERENCES category (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_169E6FB94B47A887 ON course (course_draft_id)');
        $this->addSql('CREATE INDEX IDX_169E6FB9A76ED395 ON course (user_id)');
        $this->addSql('CREATE INDEX IDX_169E6FB912469DE2 ON course (category_id)');
        $this->addSql('CREATE TABLE course_draft (id CHAR(36) NOT NULL --(DC2Type:uuid)
        , category_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) NOT NULL, image_path VARCHAR(255) DEFAULT NULL, status VARCHAR(64) NOT NULL, public_image_id VARCHAR(255) DEFAULT NULL, price DOUBLE PRECISION DEFAULT NULL, PRIMARY KEY(id), CONSTRAINT FK_AFD7917C12469DE2 FOREIGN KEY (category_id) REFERENCES category (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_AFD7917C12469DE2 ON course_draft (category_id)');
        $this->addSql('CREATE TABLE episode (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, chapter_id INTEGER NOT NULL, name VARCHAR(255) NOT NULL, description VARCHAR(255) DEFAULT NULL, video_path VARCHAR(255) DEFAULT NULL, image_path VARCHAR(255) DEFAULT NULL, public_image_id VARCHAR(255) DEFAULT NULL, public_video_id VARCHAR(255) DEFAULT NULL, is_free_to_watch BOOLEAN NOT NULL, CONSTRAINT FK_DDAA1CDA579F4768 FOREIGN KEY (chapter_id) REFERENCES chapter (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_DDAA1CDA579F4768 ON episode (chapter_id)');
        $this->addSql('CREATE TABLE episode_draft (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, chapter_draft_id INTEGER DEFAULT NULL, CONSTRAINT FK_7D7660C04EAA8D4 FOREIGN KEY (chapter_draft_id) REFERENCES chapter_draft (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_7D7660C04EAA8D4 ON episode_draft (chapter_draft_id)');
        $this->addSql('CREATE TABLE rating (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id INTEGER NOT NULL, course_id CHAR(36) NOT NULL --(DC2Type:uuid)
        , value DOUBLE PRECISION NOT NULL, message VARCHAR(255) DEFAULT NULL, CONSTRAINT FK_D8892622A76ED395 FOREIGN KEY (user_id) REFERENCES user (id) NOT DEFERRABLE INITIALLY IMMEDIATE, CONSTRAINT FK_D8892622591CC992 FOREIGN KEY (course_id) REFERENCES course (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_D8892622A76ED395 ON rating (user_id)');
        $this->addSql('CREATE INDEX IDX_D8892622591CC992 ON rating (course_id)');
        $this->addSql('CREATE TABLE reset_password_request (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id INTEGER NOT NULL, selector VARCHAR(20) NOT NULL, hashed_token VARCHAR(100) NOT NULL, requested_at DATETIME NOT NULL --(DC2Type:datetime_immutable)
        , expires_at DATETIME NOT NULL --(DC2Type:datetime_immutable)
        , CONSTRAINT FK_7CE748AA76ED395 FOREIGN KEY (user_id) REFERENCES user (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('CREATE INDEX IDX_7CE748AA76ED395 ON reset_password_request (user_id)');
        $this->addSql('CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username VARCHAR(180) NOT NULL, roles CLOB NOT NULL --(DC2Type:json)
        , password VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL, is_verified BOOLEAN NOT NULL, public_image_id VARCHAR(255) DEFAULT NULL, image_path VARCHAR(255) DEFAULT NULL)');
        $this->addSql('CREATE UNIQUE INDEX UNIQ_IDENTIFIER_USERNAME ON user (username)');
        $this->addSql('CREATE TABLE messenger_messages (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, body CLOB NOT NULL, headers CLOB NOT NULL, queue_name VARCHAR(190) NOT NULL, created_at DATETIME NOT NULL --(DC2Type:datetime_immutable)
        , available_at DATETIME NOT NULL --(DC2Type:datetime_immutable)
        , delivered_at DATETIME DEFAULT NULL --(DC2Type:datetime_immutable)
        )');
        $this->addSql('CREATE INDEX IDX_75EA56E0FB7336F0 ON messenger_messages (queue_name)');
        $this->addSql('CREATE INDEX IDX_75EA56E0E3BD61CE ON messenger_messages (available_at)');
        $this->addSql('CREATE INDEX IDX_75EA56E016BA31DB ON messenger_messages (delivered_at)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('DROP TABLE cart');
        $this->addSql('DROP TABLE cart_course');
        $this->addSql('DROP TABLE category');
        $this->addSql('DROP TABLE chapter');
        $this->addSql('DROP TABLE chapter_draft');
        $this->addSql('DROP TABLE course');
        $this->addSql('DROP TABLE course_draft');
        $this->addSql('DROP TABLE episode');
        $this->addSql('DROP TABLE episode_draft');
        $this->addSql('DROP TABLE rating');
        $this->addSql('DROP TABLE reset_password_request');
        $this->addSql('DROP TABLE user');
        $this->addSql('DROP TABLE messenger_messages');
    }
}
