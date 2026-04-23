package runner;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:").relativeTo(getClass());
    }

    @Karate.Test
    Karate testUsers() {
        return Karate.run("classpath:users").relativeTo(getClass());
    }

    @Karate.Test
    Karate testOrders() {
        return Karate.run("classpath:orders").relativeTo(getClass());
    }

}
