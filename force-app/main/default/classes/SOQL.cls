/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Simon Lapointe
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
        public static List<Lead> getAllLeads () {
            List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
            return allLeads;
        }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
        public static List<Contact> getContactsByFirstName () {
            List<Contact> con= [
                SELECT Id, Name, FirstName 
                FROM Contact 
                WHERE FirstName = 'John'
                ];
            return con;
        }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
        public static List<Id> getContactIdsByLastName () {
        List<Contact> con = [
            SELECT Id 
            FROM Contact 
            WHERE LastName IN ('Smith', 'Jones')
            ]; 

        List<Id> conIds = new List<Id>(); 
        for(Contact c : con) { 
            conIds.add(c.Id);
        }   
        return conIds;
        }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
        public static List<Opportunity> getClosedWonOpportunityCountByAccount (String accountId) {
            List<Opportunity> opps = [
                SELECT Id, Name, AccountId, StageName, CloseDate, Amount
                FROM Opportunity 
                WHERE AccountId = :accountId AND StageName = 'Closed Won'
                ];
            return opps;
        }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount () {
        Integer count = [SELECT COUNT() FROM Account];
        return count;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
    Map <Id, Task> idAndTaskMap = new Map <Id, Task>();
    Date today = Date.today();
    Date nextWeek = today.addDays(7);
    List <Task> tasksDue = [
        SELECT Id, Subject, ActivityDate 
        FROM Task 
        WHERE ActivityDate >= :today 
        AND ActivityDate <= :nextWeek
        ];

        for(Task t : tasksDue) { 
            idAndTaskMap.put(t.id, t);
        }
    return idAndTaskMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
        List<Contact> con = [
            SELECT Id, Name, Email
            FROM Contact
            WHERE Email LIKE '%example.com%'
            ];
        return con;    
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        List<Opportunity> opps = [
            SELECT Id, Name 
            FROM Opportunity 
            WHERE Name LIKE :'%' + keyword + '%'
            ];
        return opps; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> cases = [
            SELECT Id, Origin, Status, AccountId
            FROM Case
            WHERE Origin NOT IN ('Web', 'Email', '') 
            AND Origin != null
            ];
        return cases; 
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String keyword) {
    List<Lead> foundLeads = [
        SELECT Id, LeadSource, Title, LastName, Company, Phone, Email
        FROM Lead
        WHERE LeadSource = :leadSource OR Title LIKE :'%' + keyword + '%'
        ];
        return foundLeads;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        List<String>ContactsLastNames = new List<String>();

        List<Contact> contactsWithAccount = [
            SELECT Id, LastName, accountId 
            FROM Contact 
            WHERE accountId = :accountId];

        for (Contact c : contactsWithAccount) {
            ContactsLastNames.add(c.LastName);
        }
        return ContactsLastNames; 
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        AggregateResult[] results = [SELECT SUM(Amount) totalAmount FROM Opportunity WHERE StageName = :stage OR Amount > 10000];
        Decimal totalRevenue = (Decimal)results[0].get('totalAmount');
        return totalRevenue; 
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        List<Account> firstTenAccounts =    [
            SELECT Id, Name 
            FROM Account 
            ORDER BY Name ASC LIMIT 10
            ];
        return firstTenAccounts; 
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        List<Opportunity> highValueOpps = [
            SELECT Id, Amount, CloseDate 
            FROM Opportunity 
            WHERE Amount > 100000 
            ORDER BY CloseDate ASC LIMIT 5
            ];
        return highValueOpps; 
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        List<Contact> contactBirthdays = [
            SELECT Id, Birthdate 
            FROM Contact 
            ORDER BY Birthdate DESC LIMIT 3];
    
        return contactBirthdays; 
    }
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        List<Case> casesWithStatus = [
            SELECT Id, Status, CreatedDate 
            FROM Case 
            WHERE Status = 'Open' 
            ORDER BY CreatedDate ASC LIMIT 10 OFFSET 5
            ];
        return casesWithStatus; 
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        Set<Id> caseIds = new Set<Id>();

        List<Case> accountCases = [
            SELECT Id, AccountId 
            FROM Case 
            WHERE AccountId = :accountId
            ];
            
        for (case c : accountCases) {
            caseIds.add(c.Id);
        }
        return caseIds; 
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        Map<Id, String> accountIdsToNamesMap = new Map<Id, String>();

        List<Account> myAccounts =  [
            SELECT Id, BillingCountry, Name 
            FROM Account 
            WHERE BillingCountry != :country
            ];

        for (account a : myAccounts){
            accountIdsToNamesMap.put(a.Id, a.Name);
        }
        return accountIdsToNamesMap; 
    }
    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        List<Contact> contacts = [
            SELECT Id, Name, Account.Name 
            FROM Contact 
            WHERE Id = :contactId
            ];

        String accountName = contacts[0].Account.Name;
        return accountName; 
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        List <Account> acc = [
            SELECT Id, Name, (
                SELECT Id, Name 
                FROM Opportunities) 
            FROM Account 
            WHERE Id = :accountId
            ];

        return acc[0]; 
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        List<Account> accounts = [
            SELECT Id, BillingState 
            FROM Account 
            WHERE Id = :accountId
            ];

        String accountBillingState = accounts[0].BillingState;

        List<Contact> contacts = [
            SELECT Id, MailingState 
            FROM Contact 
            WHERE MailingState = :accountBillingState
            ];

        return contacts; 
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        List<Lead> myLeads = [
            SELECT Id, Email 
            FROM Lead 
            WHERE Id 
            IN :leadIds
            ];
        
        Set<String> emailDomains = new Set<String>();
        
            for (lead l : myLeads){
                if(l.email != null){
                    emailDomains.add('%' + l.Email.substringAfter('@') + '%');
            }
        }

        List<Account> accountsFound = [   
            SELECT Id, Name, Website 
            FROM Account 
            WHERE Website 
            LIKE :('%' + String.join(new List<String>(emailDomains), '%') + '%')
            ];
        return accountsFound;
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        List<OpportunityLineItem> oppLineItems= [
            SELECT Id, OpportunityId, Quantity, PricebookEntryId, UnitPrice
            FROM OpportunityLineItem
            WHERE OpportunityId = :origOppId
            ];

        List<OpportunityLineItem> newLineItems = new List<OpportunityLineItem>();

        Integer genNum = Integer.valueOf(Math.random() * 3 + 1);

        for(Id cloneId : cloneOppIds){
            for(OpportunityLineItem oppLI : oppLineItems){
                OpportunityLineItem newItem = new OpportunityLineItem(
                    OpportunityId = cloneId,
                    Quantity = genNum,
                    PriceBookEntryId = oppLI.PriceBookEntryId,
                    UnitPrice = oppLI.UnitPrice
                );
                newLineItems.add(newItem);
            }
        }
        insert newLineItems;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        List<Opportunity> oppClosedWon = [
        SELECT Id, Name, StageName, Account.Name, Owner.Name
        FROM Opportunity
        WHERE StageName = 'Closed Won'
        ];

        return oppClosedWon; 
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : closedWonOpps){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }
        }
        List<Contact> contacts = [
            SELECT Id, Name, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
            ORDER BY CreatedDate DESC
            ];
        Map<Id, Id> accContacMap = new Map<Id, Id>();
        for (Contact c : contacts){
            accContacMap.put(c.AccountId, c.Id);
        }
        for(Opportunity opp : closedWonOpps){
            opp.Primary_Contact__c = accContacMap.get(opp.AccountId);
        }
        update closedWonOpps;
    }
}