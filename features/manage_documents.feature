Feature: Manage Users
  In order to share and publish his documents
  the user
  wants to manage documents

  Background:
    Given I am a new, authenticated user      

  Scenario: Create a document
    Given I am on the "documents/add" page
    And I fill in "Titre" with "Document de test"
    And I fill in "Description" with "Une description courte"
    And I fill in "Etiquettes" with "tag1, tag2"
    When I press "Creer votre document"
    Then I should see "Votre document a bien été crée"

  Scenario: Edit a document
    Given a document exists
    And I am on the document's edit page
    And I fill in "Description" with "Une autre description"
    When I press "Modifier ce document"
    Then I should see "Votre document a bien été édité" 
    And I should see "Une autre description"

  Scenario: Destroy a document
    Given a document exists
    And I am on the document's page
    When I follow "Détruire"
    Then I should see "Votre document a bien été détruit" 
    And the document should not exist

  Scenario: Upload a file via http
    Given a document exists
    And I am on the document's upload page
    And I attach the file "spec/fixtures/one-second.ogg" to "Fichier"
    When I press "Déposer votre fichier"
    Then I should see "Votre fichier a bien été déposé"
    And the document should be uploaded

  Scenario: Upload a file via ftp
    Given a document exists
    And I am on the document's upload page
    And I upload the file "spec/fixtures/one-second.ogg" to the specified ftp url
    When I press "Confirmer le dépôt"
    Then I should see "Votre fichier a bien été déposé"
    And the document should be uploaded
