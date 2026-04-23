function fn() {
    var env = karate.env || 'dev';
    karate.log('Environment:', env);

    var config = {
        env: env,
        connectTimeout: 5000,
        readTimeout: 10000
    };

    if (env === 'dev') {
        config.baseUrl = 'https://jsonplaceholder.typicode.com';
    } else if (env === 'qa') {
        config.baseUrl = 'https://qa.api.example.com';
    } else if (env === 'prod') {
        config.baseUrl = 'https://api.example.com';
    }

    karate.configure('connectTimeout', config.connectTimeout);
    karate.configure('readTimeout', config.readTimeout);

    return config;
}
