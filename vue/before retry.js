import axios from 'axios';

const Api = axios.create({
  baseURL: process.env.VUE_APP_FC2_API
});

// Add a request interceptor
Api.interceptors.request.use(
  async function(config) {
    let accessToken = localStorage.getItem('accessToken');
    console.log('@accessToken=====>', accessToken);
    config.headers = {
      Authorization: `Bearer ${accessToken}`,
      Accept: 'application/json'
    };
    return config;
  },
  function(error) {
    // Do something with request error
    return Promise.reject(error);
  }
);
// Add a response interceptor
Api.interceptors.response.use(
  function(response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    return response;
  },
  async function(error) {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    console.log('@response.error====>', error.config);
    console.log('@response.error.status====>', error.response.status);
    const originalRequest = error.config;
    const refreshToken = localStorage.getItem('refreshToken');
    const errorStatus = error.response.status;
    console.log('@refreshToke==========>', refreshToken);
    console.log('@refreshToke==========>', !refreshToken);
    console.log('@refreshToke==========>', refreshToken == 'null');

    if (errorStatus === 401 && !originalRequest.retry && refreshToken) {
      console.log('1#####################################');
      originalRequest.retry = true;
      console.log('토큰이 이상한 오류일 경우');
      return fetch('http://127.0.0.1:9090/api/auth/refresh/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          refreshToken: refreshToken
        })
      })
        .then(res => res.json())
        .then(res => {
          console.log('@retry.jwt====>', res);
          localStorage.setItem('accessToken', res.accessToken);
          localStorage.setItem('refreshToken', res.refreshToken);
          originalRequest.headers['Authorization'] =
            'Bearer ' + res.accessToken;
          return axios(originalRequest);
        });
    } else {
      console.log('2#####################################');
      // need else block to handle other error status
      if (errorStatus === 404) {
        console.error('404 error');
      }
    }
    return Promise.reject(error);
  }
);

export default Api;
