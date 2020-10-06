# Exercise 1

In this exercise, we will create...

## Create the Service Consumption Model

After completing these steps you will have created...

1. Click here.
<br>![](/exercises/ex1/images/01_01_0010.png)

2.	Insert this line of code.
```abap
response->set_text( |Hello World! | ). 
```



## Create a console application to test the OData service

After completing these steps you will have...

1.	Enter this code.
```abap
DATA(lt_params) = request->get_form_fields(  ).
READ TABLE lt_params REFERENCE INTO DATA(lr_params) WITH KEY name = 'cmd'.
  IF sy-subrc <> 0.
    response->set_status( i_code = 400
                     i_reason = 'Bad request').
    RETURN.
  ENDIF.

```

2.	Click here.
<br>![](/exercises/ex1/images/01_02_0010.png)

## Create a custom entity

## Create a query implementation class

## Add the custom entity to your service definition

## Add the custom entity as a value help

## Test the service 

## Summary
You've now ...

Continue to - [Exercise 2 - Exercise 2 Description](../ex2/README.md)

