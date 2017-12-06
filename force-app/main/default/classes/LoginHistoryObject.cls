global with sharing class LoginHistoryObject {
    
    @AuraEnabled
    global String userID { get;set; }
    @AuraEnabled
    global String userFullName { get;set; }
    @AuraEnabled
    global String LoginTime { get;set; }
    @AuraEnabled
    global String Application { get;set; }
    @AuraEnabled
    global String iconUrl { get;set; }
    @AuraEnabled
    global String objStatus { get;set; }
    @AuraEnabled
    global String ErrorMsg { get;set; }
    
    //Constructor
    global LoginHistoryObject(String recID) {
        this.userID = recID;
       
    }
    
     @AuraEnabled
    global static List<LoginHistoryObject> getLoginHistoryLimit(String uStatus, string rowsLimit)
    {
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## uStatus: ' + uStatus);   
        
        List<LoginHistoryObject> lstPosts = new List<LoginHistoryObject>();
        Integer rLimit = integer.valueOf(rowsLimit);
        System.debug('######## rLimit: ' + rLimit);
        // Get List of EntitySubscription for current user
        // add crud/fls check
        if (Schema.sObjectType.LoginHistory.isQueryable())
        {
            List<LoginHistory> lstLoginHist = [SELECT Application, LoginTime,Status,UserId 
                                                  FROM LoginHistory order by logintime desc limit 600];
            
            System.debug('######## lstLoginHist.size: ' + lstLoginHist.size());       
            System.debug('######## lstLoginHist: ' + lstLoginHist);
            
            Set<ID> setUserIds = new Set<ID>();
            
            // Create List of LoginHistoryObject 
            
            Integer counter = 0;
            
            for (LoginHistory e: lstLoginHist)
            {
                
                LoginHistoryObject i = new LoginHistoryObject(e.UserId);
                i.Application = e.Application ;
                i.LoginTime = e.LoginTime.format('MM/dd/YY HH:mm:ss') ;
                
                ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, e.UserId);
                if (userPhoto != null)
                    i.iconUrl = userPhoto.smallPhotoUrl;
                
                i.objStatus = e.Status;
                String theStatus = e.Status;
                i.ErrorMsg = '';
                System.debug('######## i.objStatus: ' + i.objStatus);
                if (!i.objStatus.equalsIgnoreCase('Success'))
                {
                    i.ErrorMsg = i.objStatus.replace('Failed: ', '');
                    i.objStatus = 'Failed';
                }
                    
                
                System.debug('######## i.Application : ' + i.Application );
                System.debug('######## i.LoginTime: ' + i.LoginTime);
                System.debug('######## i.iconUrl: ' + i.iconUrl);            
                System.debug('######## i.objStatus: ' + i.objStatus);
                System.debug('######## i.ErrorMsg: ' + i.ErrorMsg);
                
               
                    if (i.objStatus.contains(uStatus) || uStatus.equalsIgnoreCase('All Status'))
                    {
                        if (counter < rLimit)
                        {
                            lstPosts.add(i);
                            setUserIds.add(i.userID);
                        }
                        else
                            break;
                        counter ++;
                    }      
            }   
        System.debug('######## lstPosts: ' + lstPosts);
            
            // Get User Information
            // Add crud/fls check
            if (Schema.sObjectType.User.isQueryable())
            {
                Map<ID, String> mapUserInfo = new Map<ID, String>();    
                for (User u : [Select id, name from User where id in: setUserIds]) {
                    mapUserInfo.put(u.id, u.name);
                }
                
                // Assign user info to list of login users
                
                for (LoginHistoryObject p: lstPosts)
                {
                    p.userFullName = mapUserInfo.get(p.userID);
                }
            }

    	}    
	return lstPosts;
        
    }
    
    @AuraEnabled
    global static List<LoginHistoryObject> getLoginHistoryLimitInt(String uStatus, Integer rowsLimit)
    {
        System.debug('######## rowsLimit: ' + rowsLimit);
        System.debug('######## uStatus: ' + uStatus);   
        
        List<LoginHistoryObject> lstPosts = new List<LoginHistoryObject>();
        // Get List of EntitySubscription for current user
        if (Schema.sObjectType.LoginHistory.isAccessible())
        {
            List<LoginHistory> lstLoginHist = [SELECT Application, LoginTime,Status,UserId 
                                                  FROM LoginHistory order by logintime desc limit 600];
            
            System.debug('######## lstLoginHist.size: ' + lstLoginHist.size());       
            System.debug('######## lstLoginHist: ' + lstLoginHist);
            
            Set<ID> setUserIds = new Set<ID>();
            
            // Create List of LoginHistoryObject 
            
            Integer counter = 0;
            
            for (LoginHistory e: lstLoginHist)
            {
                
                roreblcloghist.LoginHistoryObject i = new roreblcloghist.LoginHistoryObject(e.UserId);
                i.Application = e.Application ;
                i.LoginTime = e.LoginTime.format('MM/dd/YY HH:mm:ss') ;
                
                ConnectApi.Photo userPhoto = ConnectApi.ChatterUsers.getPhoto(null, e.UserId);
                if (userPhoto != null)
                    i.iconUrl = userPhoto.smallPhotoUrl;
                
                i.objStatus = e.Status;
                String theStatus = e.Status;
                i.ErrorMsg = '';
                System.debug('######## i.objStatus: ' + i.objStatus);
                if (!i.objStatus.equalsIgnoreCase('Success'))
                {
                    i.ErrorMsg = i.objStatus.replace('Failed: ', '');
                    i.objStatus = 'Failed';
                }
                    
                
                System.debug('######## i.Application : ' + i.Application );
                System.debug('######## i.LoginTime: ' + i.LoginTime);
                System.debug('######## i.iconUrl: ' + i.iconUrl);            
                System.debug('######## i.objStatus: ' + i.objStatus);
                System.debug('######## i.ErrorMsg: ' + i.ErrorMsg);
                
               
                    if (i.objStatus.contains(uStatus) || uStatus.equalsIgnoreCase('All Status'))
                    {
                        System.debug('######## got inside if line 160');
                        System.debug('######## counter: ' + counter);
                        System.debug('######## rowsLimit: ' + rowsLimit);
                        Integer rLimit = Integer.valueOf(rowsLimit);
                        if (counter < rLimit)
                        {
                            System.debug('######## got inside if line 165');
                            lstPosts.add(i);
                            setUserIds.add(i.userID);
                        }
                        else
                            break;
                        counter ++;
                    }      
            }   
        System.debug('######## lstPosts: ' + lstPosts);
            
            // Get User Information
            if (Schema.sObjectType.User.isAccessible())
        	{
                Map<ID, String> mapUserInfo = new Map<ID, String>();    
                for (User u : [Select id, name from User where id in: setUserIds]) {
                    mapUserInfo.put(u.id, u.name);
                }
                
                // Assign user info to list of login users
                
                for (LoginHistoryObject p: lstPosts)
                {
                    p.userFullName = mapUserInfo.get(p.userID);
                }
        	}

      }  
	return lstPosts;
        
    }
        


}