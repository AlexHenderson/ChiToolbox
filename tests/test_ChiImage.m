classdef test_ChiImage < matlab.unittest.TestCase

    
    properties
        im
        xvals
        yvals
    end
    
    % =====================================================================
    methods (TestMethodSetup)
        function createChiImage(this)

            this.yvals = magic(10);
            this.yvals = cat(3,this.yvals,this.yvals+2);
            this.yvals = cat(3,this.yvals,this.yvals+2);
            this.yvals = cat(3,this.yvals,this.yvals+2);
            this.yvals = cat(3,this.yvals,this.yvals+2);

            dims=size(this.yvals);

            this.xvals=1:dims(3);

%             ChiImage(xvals,data,xpixels,ypixels,reversex,xlabelname,xlabelunit,ylabelname,ylabelunit,masked,mask,filenames)
            this.im = ChiImage(this.xvals,this.yvals,dims(2),dims(1),false);
            
        end
    end    
    
    % =====================================================================
    methods (Test)
        
        function test_numchannels(this)
            this.verifyEqual(this.im.numchannels(), 16);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_removerangeidx(this)
            this.im = this.im.removerangeidx(3,6);
            this.verifyEqual(this.im.numchannels(), 12);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_removerange(this)
            this.im = this.im.removerange(3,6);
            this.verifyEqual(this.im.numchannels(), 12);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_totalspectrum(this)
            expected = ChiSpectrum(this.im.xvals,[5050,5250,5250,5450,5250,5450,5450,5650,5250,5450,5450,5650,5450,5650,5650,5850]);
            spec = this.im.totalspectrum();
            expected.history = spec.history.clone();
            this.verifyEqual(spec, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_totalspectrumfollowingremoval(this)
            this.im = this.im.removerangeidx(3,6);
            spec = this.im.totalspectrum();
            expectedxvals = [1,2,7,8,9,10,11,12,13,14,15,16];
            expectedyvals = [5050,5250,5450,5650,5250,5450,5450,5650,5450,5650,5650,5850];
            expected = ChiSpectrum(expectedxvals,expectedyvals);
            expected.history = spec.history.clone();
            this.verifyEqual(spec, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_applymask(this) % spectrum
            mask = true(this.im.ypixels,this.im.xpixels);
            mask(3:6,3:6) = 0;
            this.im = this.im.applymask(mask);
            totalspectrum = this.im.totalspectrum();
            expected_totalspectrum = [4375,4543,4543,4711,4543,4711,4711,4879,4543,4711,4711,4879,4711,4879,4879,5047];
            expected_totalspectrum = ChiSpectrum(this.im.xvals,expected_totalspectrum);
%             expected.history = im.history.clone();
            this.verifyEqual(totalspectrum, expected_totalspectrum);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_applymask2(this) % this.image
            mask = true(this.im.ypixels,this.im.xpixels);
            mask(3:6,3:6) = 0;
            this.im = this.im.applymask(mask);
            totalimage = this.im.totalimage;
            expected_totalimage = [1536,1648,80,192,304,1136,1248,880,992,704;1632,1344,176,288,320,1232,944,976,1088,720;128,1360,0,0,0,0,960,1072,1184,816;1424,1456,0,0,0,0,1056,1168,1200,512;1440,1552,0,0,0,0,1152,1264,896,608;336,448,0,0,0,0,848,480,592,1104;432,144,1376,1488,1520,832,544,576,688,1120;1328,160,272,1584,1616,528,560,672,784,1216;224,256,1568,1600,1312,624,656,768,800,912;240,352,1664,1296,1408,640,752,864,496,1008];
            expected_totalimage = ChiPicture(expected_totalimage);
%             expected_totalimage.history = spec.history.clone();
            this.verifyEqual(totalimage, expected_totalimage);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_crop(this) % spectrum
            %output = crop(this, lowx,highx, lowy,highy)
            lowx = 3;
            highx = 6;
            lowy = 3;
            highy = 6;
            out = this.im.crop(lowx,highx, lowy,highy);

            totalspectrum = out.totalspectrum();
            expected_totalspectrum = [675,707,707,739,707,739,739,771,707,739,739,771,739,771,771,803];
            expected_totalspectrum = ChiSpectrum(this.im.xvals,expected_totalspectrum);
%             expected_totalspectrum.log = this.im.log;
            this.verifyEqual(totalspectrum, expected_totalspectrum);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_crop2(this) % this.image
            %output = crop(this, lowx,highx, lowy,highy)
            lowx = 3;
            highx = 6;
            lowy = 3;
            highy = 6;
            out = this.im.crop(lowx,highx, lowy,highy);
            totalimage = out.totalimage();
            expected_totalimage = [1472,384,416,928;368,400,112,1024;464,96,208,1040;1280,1392,1504,736];
            expected_totalimage = ChiPicture(expected_totalimage);
%             expected_totalthis.image.log = this.im.log;
            this.verifyEqual(totalimage, expected_totalimage);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_sumrangeidx(this) % x index range
            % rangethis.image = sumrangeidx.m(this,fromidx,toidx);

            expected = ChiPicture([288,309,15,36,57,213,234,165,186,132;306,252,33,54,60,231,177,183,204,135;24,255,276,72,78,174,180,201,222,153;267,273,69,75,21,192,198,219,225,96;270,291,87,18,39,195,216,237,168,114;63,84,240,261,282,138,159,90,111,207;81,27,258,279,285,156,102,108,129,210;249,30,51,297,303,99,105,126,147,228;42,48,294,300,246,117,123,144,150,171;45,66,312,243,264,120,141,162,93,189]);
            expected.history = [];
            range = this.im.sumrangeidx(7,9);
            range.history = [];
            this.verifyEqual(range, expected);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_sumrangeidx2(this) % single x index
            % rangethis.image = summedrangethis.imagefromindexvals(this,fromidx,toidx);

            expected = ChiPicture([94,101,3,10,17,69,76,53,60,42;100,82,9,16,18,75,57,59,66,43;6,83,90,22,24,56,58,65,72,49;87,89,21,23,5,62,64,71,73,30;88,95,27,4,11,63,70,77,54,36;19,26,78,85,92,44,51,28,35,67;25,7,84,91,93,50,32,34,41,68;81,8,15,97,99,31,33,40,47,74;12,14,96,98,80,37,39,46,48,55;13,20,102,79,86,38,45,52,29,61]);
            expected.history = [];
            range = this.im.sumrangeidx(9);
            range.history = [];
            this.verifyEqual(range, expected);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_clone_same(this)
            cloned = this.im.clone();
            cloned.history = [];
            this.im.history = [];
            this.verifyEqual(this.im, cloned);
        end

        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        function test_clone_different(this)
            cloned = this.im.clone();
            changed = this.im.keeprange(6,3);
            cloned.history = [];
            changed.history = [];
            this.verifyNotEqual(cloned, changed);
        end
        
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    end
end
