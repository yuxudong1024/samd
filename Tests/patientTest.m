classdef patientTest < matlab.unittest.TestCase
    properties
        names
        vars = {20,1,1:10,1};
    end

    properties (TestParameter)
        nameIndex = num2cell(50:5:120);
        validAge = num2cell(0:10:80);
        invalidAge = {-50, -20, 190, 500, 10000, -inf, NaN, struct};
        validId = num2cell(1:1:10);
        invalidId = {'a',"214",struct,"h3ll0"};
        validFreq = num2cell(1:2:20);
        invalidFreq = {0, [2 5 10], -1, 2.2, struct, NaN, inf, -inf};
        invalidSig = {0, struct, 'aaa'};
    end

    methods(TestClassSetup)
        function loadData(testCase)
            nl = load('nameslist.mat','nameslist');
            testCase.names = nl.nameslist;
        end
    end
    
    methods(Test, TestTags={'partest'})  
        function validNameString(testCase, nameIndex)
            first = testCase.names(nameIndex);
            last = testCase.names(nameIndex);
            v = testCase.vars;
            cmd = @() patient(first, last, v{:});
            verifyWarningFree(testCase, cmd)
        end
        function validNameChar(testCase, nameIndex)
            v = testCase.vars;
            first = testCase.names(nameIndex);
            last = testCase.names(nameIndex);
            cmd = @() patient(char(first), char(last), v{:});
            verifyWarningFree(testCase, cmd)
        end
        function invalidName(testCase)
            v = testCase.vars;
            cmd = cell(2, 1);
            cmd{1} = @() patient(1234, "last", v{:});
            cmd{2} = @() patient("first", 1234, v{:});
            for i = 1:numel(cmd)
                verifyError(testCase, cmd{i}, 'patient:InvalidName')
            end
        end
        function invalidString(testCase)
            % This should error out because names are not alphabetic
            % strings -- How to fix this test?
            v = testCase.vars;
            cmd{1} = @() patient("f1rst", "last", v{:});
            cmd{2} = @() patient("first", "l4st", v{:});
            cmd{3} = @() patient("f1rst", "l4st", v{:});
            for i = 1:numel(cmd)
                verifyError(testCase, cmd{i}, 'patient:InvalidName')
            end
        end
        function validAgeTest(testCase, validAge)
            v = testCase.vars;
            cmd = @() patient("first", "last", validAge, v{2:end});
            verifyWarningFree(testCase, cmd)
        end
        function invalidAgeTest(testCase, invalidAge)
            v = testCase.vars;
            cmd = @() patient("first", "last", invalidAge, v{2:end});
            verifyError(testCase, cmd, 'patient:InvalidAge')
        end
        function validIdTest(testCase, validId)
            v = testCase.vars;
            cmd = @() patient("first", "last", 1, validId, v{3:end});
            verifyWarningFree(testCase, cmd);
        end
        function invalidIdTest(testCase, invalidId)
            v = testCase.vars;
            cmd = @() patient("first", "last", 1, invalidId, v{3:end});
            verifyError(testCase, cmd, 'patient:InvalidId')
        end
        function validFrequency(testCase, validFreq)
            v = testCase.vars;
            cmd = @() patient("first", "last", v{1:3}, validFreq);
            verifyWarningFree(testCase, cmd)
        end
        function invalidFrequency(testCase, invalidFreq)
            v = testCase.vars;
            cmd = @() patient("first", "last", v{1:3}, invalidFreq);
            verifyError(testCase, cmd, 'patient:InvalidFreq')
        end
        function validSignal(testCase, validFreq)
            signal = randn(4096, 1);
            cmd = @() patient("first", "last", 1, 1, signal, validFreq);
            verifyWarningFree(testCase, cmd)
        end
        function invalidSignal(testCase, invalidSig)
            cmd = @() patient("first", "last", 1, 1, invalidSig, 128);
            verifyError(testCase, cmd, 'patient:InvalidSignal')
        end
    end
    
end