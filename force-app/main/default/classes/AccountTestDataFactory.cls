/**
* @Name  AccountTestDataFactory
* @description Account test data factory 
* @date    14/08/2022
* @author  Sudhakar Y
*/
@isTest
public class AccountTestDataFactory {
    public static Account createAccount(Boolean doInsert) {
        return createAccount('testAccount', doInsert);
    }
    
    public static Account createAccount(String name, Boolean doInsert) {
        Account acc = new Account(name = name);
        if(doInsert) {
            insert acc;
        }
        return acc;
    }
}