@isTest
private class test_LoginHistory {
    
    
    @isTest static void testConstructor() {
 
        LoginHistory lh = [SELECT id, Application, LoginTime,Status,UserId 
                                              FROM LoginHistory limit 1];
        
        Test.startTest();
        LoginHistoryObject lObj = new LoginHistoryObject(lh.id);
        System.assertNotEquals(null, lObj);
        Test.stopTest();
    }
    
        @isTest(SeeAllData=true) static void testGetLoginHistoryLimit() {

        LoginHistory lh = [SELECT id, Application, LoginTime,Status,UserId 
                                              FROM LoginHistory limit 1];
        
        Test.startTest();
        List<LoginHistoryObject> lstRecs = LoginHistoryObject.getLoginHistoryLimit('Success', '1');
        System.assertNotEquals(null, lstRecs);
            
        List<LoginHistoryObject> lstRecsInt = LoginHistoryObject.getLoginHistoryLimitInt('Success', 1);
        System.assertNotEquals(null, lstRecsInt);  
            
        Test.stopTest();
        
    }

}