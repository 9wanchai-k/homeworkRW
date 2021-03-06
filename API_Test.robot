*** Settings ***

Library  RequestsLibrary
Library  JSONLibrary

Library  Collections

*** Variables ***
${URL}      https://jsonplaceholder.typicode.com


*** Test Cases ***
Homework5
    Create Session      GetAssets     ${URL}
    ${my_response}=     Get Request    GetAssets     /users
    ${my_response_json}=    Convert String To JSON     ${myresponse.content}
    #5.1    HTTP Status code
    Should Be Equal As Integers     ${my_response.status_code}      200      #check status = 200



    #5.2    Response Return type
    ${check_headers} =        get from dictionary     ${my_response.headers}   Content-Type    #check key
    Should Be Equal     ${check_headers}  application/json; charset=utf-8    #check value


    #5.3    Response Data type
    ${checktype_id}=    Evaluate     type(${my_response_json[0]['id']})
    ${results_name}=    Evaluate     isinstance(${my_response_json[0]['id']}, int)
    Should Be True      ${results_name}
    Log To Console      ${results_name}

    ${checktype_address}=  Evaluate     type(${my_response_json[0]['address']})
    ${results_address}=   Evaluate      isinstance(${my_response_json[0]['address']}, dict)
    Should Be True      ${results_address}
    Log To Console      ${results_address}

    #5.4    Response Data size
    ${length_json}=     Get Length   ${my_response_json}
    Log To Console      ${length_json}
    ${compare_result}=  evaluate    ${length_json} > 1
    Should Be Equal     '${compare_result}'   'True'


Homework6
    ${header}=  Create Dictionary   Content-Type=application/json; charset=utf-8
    Create Session      PostAssets     ${URL}
    ${my_post}=        POST Request     PostAssets      /posts    data={"title":"foo","body":"bar","userId":1}     headers=${header}

    #6.1    HTTP Status code
    Log To Console     ${my_post.status_code}
    Should Be Equal As Integers     ${my_post.status_code}      201

    #6.2    Response Header
    ${check_headers_Content} =        get from dictionary     ${my_post.headers}   Content-Type    #check key
    Should Be Equal     ${check_headers_Content}  application/json; charset=utf-8    #check value
    ${check_headers_xby} =        get from dictionary     ${my_post.headers}   X-Powered-By    #check key
    Should Be Equal     ${check_headers_xby}  Express    #check value


    #6.3    Response match with Request
    ${responsePost_json}=    Convert String To JSON     ${my_post.content}
    Should Be Equal     ${responsePost_json['title']}   foo
    Should Be Equal     ${responsePost_json['body']}    bar
    Should Be Equal As Integers     ${responsePost_json['userId']}   1



