//Router 1X1 testplan document
//This testplan is to verify the functionality of the design : router 1 X 1. It includes basic functionality checks, error injection tests, and erroneous tests

// base_test : The purpose of this test is to verify the basic functionality of the design through self-checking mechanism. This includes standard packet sequences as per the design - PASS

//new_test1 : The purpose of this test is to override the constraints and alter the number of packets in the environment - PASS

//new_test2 : This test is to send the stimulus from a single source port to various destination ports using constraints (SA2 -> DA*) - PASS

//new_test3 : This test is to send the stimulus to a single destination port from various destination ports using constraints (SA* -> DA3) - PASS

//new_test4 : This test is to send the stimulus SA4 -> DA4 - PASS

//new_test5 : This test is to send the stimulus packet of equal sizes - PASS

//new_test6 : This test is to send the stimulus packet of full size(2000 Bytes) - PASS

//new_test7 : This test is to send the stimulus packets of mixed-sizes and hit the coverage - PASS
//Note: used $finish to quit the simulation in coverage component

//erroneous test
//new_test8 : This test is to drive invalid da addresses in the DA port and see the behaviour of the design - PASS

//erroneous test
//new_test9 : This test is to drive the stimulus packets of invalid sizes and see the behaviour of the design - PASS

//error injection test
//new_test10 : This test is to inject invalid crc in the packet and see the behaviour of the test - PASS


