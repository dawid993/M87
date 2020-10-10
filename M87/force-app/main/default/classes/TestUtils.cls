@isTest
public class TestUtils {
    public static final String DEFAULT_TEST_USERNAME = 'testUsername7565663asd@ttest.co.pl'; 

    public static final String DEFAULT_TEST_EMAIL = 'testEmail7565663asd@ttest.co.pl';

    public static String generateRandomString(Integer length){
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,length);
    }

    public class EmailGenerator {
        private String postfix = '@mercuryTests.com.pl';

        public String generateEmail(){
            return TestUtils.generateRandomString(10) + postfix;
        }

    }
}
