public with sharing class Application {
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType> { 
                Case.SObjectType         
            }
        );	

	// Configure and create the ServiceFactory for this Application
	public static final fflib_Application.ServiceFactory Service = 
		new fflib_Application.ServiceFactory( 
			new Map<Type, Type> {
				CaseService.class => CaseServiceImp.class,
				EngagementService.class => EngagementServiceImp.class,
				UserService.class => UserServiceImp.class
            }
        );

	// Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory Selector = 
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
				Case.sObjectType => CaseSelectorImp.class,
				User.sObjectType => UserSelectorImp.class
            }
        );

	// Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain = 
		new fflib_Application.DomainFactory(
			Application.Selector,
			new Map<SObjectType, Type> {
                    
            }
        );
}

