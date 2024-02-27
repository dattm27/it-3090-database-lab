-- BÀI 1

CREATE PROC Proc_BaiTap1
AS
BEGIN
	PRINT N'Xin Chào';
END;
EXEC Proc_BaiTap1;
GO
-- BÀI 2
CREATE PROC Proc_BaiTap2
@TEN NVARCHAR(1000)
AS
	DECLARE @xinchao nvarchar(50)=N'Xin chào ';
BEGIN
	SET @xinchao=@xinchao+@TEN;
	PRINT @xinchao;
END
EXEC Proc_BaiTap2 N'Công Sơn';
GO
-- BAI3 
-- Nhập vào 2 số @s1, @s2. In ra câu ‘tổng là : @tg ‘ với @tg =@s1+@s2.

CREATE PROC BaiTap3
@s1 int ,
@s2 int 
AS 
BEGIN 
	DECLARE @tg int;
	SET @tg = @s1 + @s2;
	PRINT N'tổng là :' +cast(@tg as NVARCHAR(100)) ;
END;
EXEC BaiTap3 1, 4;
GO

--BAI4
--4. Nhập vào 2 số @s1,@s2. Xuất tổng @s1+@s2 ra tham số @tong.
CREATE PROC BaiTap4 
@s1 int,
@s2 int,
@tong int  output
AS 
BEGIN 
	SET @tong = @s1 + @s2 ;
END;

DECLARE @rowCount int ;
EXEC BaiTap4 1, 4, @rowCount OUTPUT;
SELECT @rowCount AS tong;

GO

-- Nhập vào 2 số @s1,@s2. In ra câu ‘Số lớn nhất của @s1 và @s2 là max’
-- với @s1,@s2,max là các giá trị tương ứng.

CREATE PROC Proc_Max
@s1 int,
@s2 int
AS
BEGIN 
	DECLARE @MAX int = 0
	IF @s1 < @s2
		SET @MAX = @s2
	ELSE SET @MAX = @s1
	PRINT N'Số lớn nhất của @s1 và @s2 là '+CAST(@MAX AS VARCHAR(100));
END;

EXEC Proc_Max 4, 9;

GO

--BAI5
-- Nhập vào 2 số @s1,@s2. Xuất min và max của chúng ra tham số @max.
-- Cho thực thi và in giá trị của các tham số này để kiểm tra.
CREATE PROC Proc_Min_Max
@s1 int,
@s2 int,
@MAX int output
AS 
BEGIN 
	IF @s1 < @s2
		SET @MAX = @S2
	ELSE SET @MAX = @S1
END;

DECLARE @MAX INT;
EXEC Proc_Min_Max 5, 10, @MAX OUTPUT;
SELECT @MAX AS _max;
GO

--BAI6
-- Nhập vào số nguyên @n. In ra các số từ 1 đến @n.

CREATE PROC Proc_Print_1_N
@N int
AS
	DECLARE @index INT = 0;
BEGIN
	WHILE @index <= @N
	BEGIN
		PRINT @index
		SET @index = @index +1
	END
END;
EXEC Proc_Print_1_N 10 ;
GO
--BAI7 
--Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n
CREATE PROC Proc_Print_Even_1_N
@N int
AS
	DECLARE @index int = 0;
	DECLARE @sum int = 0;
BEGIN
	WHILE @index <= @N
	BEGIN
		SET @index = @index + 1;
		IF @index % 2 = 0
			
			SET @sum = @sum + @index;
		ELSE
			CONTINUE
	END
	PRINT @sum
END;
EXEC Proc_Print_Even_1_N 10;
GO
	
-- BAi8
-- Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n 
CREATE PROC Proc_Print_Sum_Even_1_N
@N int,
@tong int output,
@count int output
AS
	DECLARE @index INT = 0;
	DECLARE @sum INT = 0;
	DECLARE @c INT = 0;
BEGIN 
	WHILE @index <= @N
	BEGIN 
		SET @index = @index + 1;
		IF(@index % 2 = 0)
			BEGIN
				SET @sum = @sum + @index;
				SET @c = @c + 1;
			END
		ELSE
			CONTINUE
	END
	SET @tong  = @sum;
	SET @count = @c;
END;
DECLARE @tong int ;
DECLARE @count int ;
EXEC Proc_Print_Sum_Even_1_N 10, @tong output, @count output;
SELECT @tong AS Tong, @count AS _count;
GO

--BAI9
--Viết store procedure tương ứng với các câu ở phần View. Sau đó cho thực
-- hiện để kiểm tra kết quả


CREATE PROC Proc_View_1
@TENQG NVARCHAR(100),
@TENCLB NVARCHAR(100)
AS
BEGIN
	SELECT MACT, HOTEN, NGAYSINH, DIACHI
	FROM CAUTHU
	WHERE MAQG = (SELECT MAQG FROM QUOCGIA
					WHERE TENQG = @TENQG)
	AND MACLB = (SELECT MACLB FROM CAULACBO
					WHERE TENCLB = @TENCLB);
END;
EXEC Proc_View_1 N'Bra-xin', N'SHB Đà Nẵng';
GO

CREATE PROC Proc_View_2
@Vong int,
@Nam int
AS
BEGIN 
	SELECT MATRAN, NGAYTD, TENSAN, CLB1.TENCLB AS CLB1, CLB2.TENCLB AS CLB2, KETQUA
	FROM TRANDAU, SANVD, CAULACBO AS CLB1 , CAULACBO AS CLB2
	WHERE TRANDAU.MASAN = SANVD.MASAN
	AND TRANDAU.MACLB1 = CLB1.MACLB
	AND TRANDAU.MACLB2 = CLB2.MACLB
	AND VONG = @Vong
	AND NAM = @Nam
END;
EXEC Proc_View_2 2, 2009;
GO


CREATE PROC Proc_View_3
@TenQG NVARCHAR(100)
AS
BEGIN
	SELECT HUANLUYENVIEN.MAHLV, TENHLV, NGAYSINH, DIACHI, VAITRO
	FROM HUANLUYENVIEN, HLV_CLB, CAULACBO
	WHERE HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
	AND HLV_CLB.MACLB = CAULACBO.MACLB
	AND MAQG = (SELECT MAQG FROM QUOCGIA
					WHERE TENQG = @TenQG)
END;
EXEC Proc_View_3 N'Việt Nam';
GO

CREATE PROC Proc_View_4 
@TenQG NVARCHAR(100),
@Count INT
AS
BEGIN
	SELECT CLB.MACLB, TENCLB, TENSAN, SANVD.DIACHI , COUNT(MACT) "SL cầu thủ nước ngoài"
	FROM CAULACBO AS CLB, SANVD, CAUTHU
	WHERE CLB.MASAN = SANVD.MASAN
	AND CAUTHU.MACLB = CLB.MACLB
	AND CAUTHU.MAQG NOT LIKE (SELECT MAQG FROM QUOCGIA 
							WHERE TENQG = @TenQG)
	GROUP BY CLB.MACLB, TENCLB, SANVD.TENSAN, SANVD.DIACHI
	HAVING COUNT(MACT) >= @Count
END;
EXEC Proc_View_4  N'Việt Nam' ,2
GO

CREATE PROC Proc_View_5
@VITRI NVARCHAR(100)
AS
BEGIN
	SELECT TENTINH, COUNT (MACT) "Số lượng cầu thủ"
	FROM TINH, CAULACBO, CAUTHU
	WHERE CAULACBO.MATINH = TINH.MATINH
	AND CAUTHU.MACLB = CAULACBO.MACLB
	AND VITRI = @VITRI
	GROUP BY TENTINH
END;
EXEC Proc_View_5 N'Tiền đạo';
GO

CREATE PROC Proc_View_6
@Nam int,
@Vong int 
AS
BEGIN
	SELECT TENCLB, TENTINH
	FROM CAULACBO, TINH, BANGXH
	WHERE CAULACBO.MATINH = TINH.MATINH
	AND BANGXH.MACLB = CAULACBO.MACLB
	AND VONG = @Vong
	AND NAM = @Nam
	AND HANG = 1
END;
EXEC Proc_View_6 2009, 3;
GO

CREATE PROC Proc_View_7
AS
BEGIN
	SELECT TENHLV
	FROM HUANLUYENVIEN, HLV_CLB
	WHERE HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
	AND DIENTHOAI IS NULL;
END;
EXEC Proc_View_7;
GO

CREATE PROC  Proc_View_8
AS
BEGIN
	SELECT TENHLV
	FROM HUANLUYENVIEN
	WHERE MAHLV NOT IN (SELECT MAHLV FROM HLV_CLB)
END;
EXEC Proc_View_8;
GO

CREATE PROC Proc_View_9
AS 
BEGIN 
	SELECT MACLB1, MACLB2, NAM, VONG,
	LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) "Số bàn thắng",
	RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA)) "Số bàn thua" 
	FROM TRANDAU;
END;
EXEC Proc_View_9;
GO

CREATE PROC Proc_View_10
AS 
BEGIN
	SELECT CAULACBO.MACLB, NAM, VONG,
	LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) "Số bàn thắng",
	RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA)) "Số bàn thua" 
	FROM CAULACBO, TRANDAU
	WHERE TRANDAU.MACLB1 = CAULACBO.MACLB
	AND TRANDAU.MASAN = CAULACBO.MASAN;
END;
EXEC Proc_View_10;
GO

CREATE PROC Proc_View_11
AS 
BEGIN
	SELECT CAULACBO.MACLB, NAM, VONG,
	LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) "Số bàn thắng",
	RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA)) "Số bàn thua" 
	FROM CAULACBO, TRANDAU
	WHERE TRANDAU.MACLB2 = CAULACBO.MACLB
	AND TRANDAU.MASAN = CAULACBO.MASAN;
END;
EXEC Proc_View_11;
GO

CREATE PROC Proc_View_12
@Nam int,
@Vong int 
AS
BEGIN 
	SELECT NGAYTD, TENSAN, CLB1.TENCLB "Tên CLB1", CLB2.TENCLB "Tên CLB2"
	FROM TRANDAU, CAULACBO AS CLB1, CAULACBO AS CLB2, SANVD
	WHERE TRANDAU.MASAN = SANVD.MASAN
	AND TRANDAU.MACLB1 = CLB1.MACLB
	AND TRANDAU.MACLB2 = CLB2.MACLB
	AND (SELECT MACLB FROM BANGXH
							WHERE VONG = @Vong
							AND NAM = @Nam 
							AND HANG = 1) IN (TRANDAU.MACLB1, TRANDAU.MACLB2);
END;
EXEC Proc_View_12 2009, 3;
GO

CREATE PROC Proc_View_13
@Nam int,
@Vong int
AS
BEGIN
	SELECT NGAYTD, TENSAN, CLB1.TENCLB "Tên CLB1", CLB2.TENCLB "Tên CLB2"
	FROM TRANDAU, CAULACBO AS CLB1, CAULACBO AS CLB2, SANVD
	WHERE TRANDAU.MASAN = SANVD.MASAN
	AND TRANDAU.MACLB1 = CLB1.MACLB
	AND TRANDAU.MACLB2 = CLB2.MACLB
	AND (SELECT MACLB FROM BANGXH
							WHERE VONG = @Vong
							AND NAM = @Nam
							AND HANG = (SELECT MAX(HANG) FROM BANGXH))  IN (TRANDAU.MACLB1, TRANDAU.MACLB2);
END;
EXEC Proc_View_13 2009, 3;
GO

-- 10. Ứng với mỗi bảng trong CSDL Quản lý bóng đá, bạn hãy viết 4 Stored
-- Procedure ứng với 4 công việc Insert/Update/Delete/Select. Trong đó
-- Stored Procedure Update và Delete lấy khóa chính làm tham số.


-- Bảng tỉnh
CREATE PROC INSERT_TINH
@MATINH VARCHAR(5),
@TENTINH NVARCHAR(100),
@RESULT NVARCHAR(100) output
AS
BEGIN
	DECLARE @COUNTS INT = 0;
	DECLARE @error INT;
	DECLARE @id INT;
	SELECT @COUNTS = COUNT(*) FROM TINH A WHERE A.MATINH=@MATINH;
	IF @COUNTS >= 1
		SET @RESULT = N'Tồn tại mã tỉnh '+@MATINH;
	ELSE
		BEGIN
			INSERT INTO TINH VALUES (@MATINH,@TENTINH);
			SELECT @error = @@ERROR, @id = SCOPE_IDENTITY(); 
			IF @error = 0
				SET @RESULT = N'Đã tạo dữ liệu cho mã tỉnh là: '+@MATINH;
			ELSE
				SET @RESULT = N'Đã xảy ra lỗi tạo dữ liệu với mã lỗi: '+@id;
			
		END;
END;
DECLARE @RESULT NVARCHAR(100);
EXEC INSERT_TINH 'HPH',N'HẢI PHÒNG',@RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

CREATE PROC UPDATE_TINH
@KEY VARCHAR(5),
@TENTINH NVARCHAR(100),
@RESULT NVARCHAR(100) output
AS
BEGIN
	DECLARE @COUNTS INT = 0;
	DECLARE @error INT;
	DECLARE @id INT;
	SELECT @COUNTS = COUNT(*) FROM TINH A WHERE A.MATINH = @KEY;
	IF @COUNTS = 0
		SET @RESULT = N'Không tìm thấy mã tỉnh: '+@KEY;
	ELSE
		BEGIN
			UPDATE TINH SET TENTINH=@TENTINH WHERE MATINH = @KEY;
			SELECT @error = @@ERROR, @id = SCOPE_IDENTITY(); 
			IF @error = 0
				SET @RESULT = N'Đã cập nhật thông tin với mã tỉnh: '+@KEY;
			ELSE
				SET @RESULT = N'Đã xảy ra lỗi cập nhật';
			
		END;
END;
DECLARE @RESULT NVARCHAR(100);
EXEC UPDATE_TINH 'HPH',N'Hải Phòng',@RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

CREATE PROC DELETE_TINH
@KEY VARCHAR(5),
@RESULT NVARCHAR(100) output
AS
BEGIN
	DECLARE @COUNTS INT = 0;
	DECLARE @error INT;
	SELECT @COUNTS = COUNT(*) FROM TINH A WHERE A.MATINH = @KEY;
	IF @COUNTS = 0
		SET @RESULT = N'Không tìm thấy mã tỉnh: '+@KEY;
	ELSE
		BEGIN
			DELETE FROM TINH WHERE MATINH = @KEY;
			SELECT @error = @@ERROR; 
			IF @error = 0
				SET @RESULT = N'Đã xóa mã tỉnh: '+@KEY;
			ELSE
				PRINT N'Đã xảy ra lỗi khi xóa mã tỉnh: '+@KEY;
		END
END;
DECLARE @RESULT NVARCHAR(100);
EXEC DELETE_TINH 'BD',@RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

CREATE PROC SELECT_TINH
@KEY VARCHAR(5),
@RESULT NVARCHAR(100) output
AS
BEGIN
	DECLARE @COUNTS INT = 0;
	DECLARE @error INT;
	SELECT @COUNTS = COUNT(*) FROM TINH A WHERE A.MATINH = @KEY;
	IF @COUNTS = 0
		SET @RESULT = N'Không tìm thấy mã tỉnh: '+@KEY;
	ELSE
		BEGIN
			SELECT * FROM TINH A WHERE A.MATINH=@KEY;
			SET @RESULT =N'Tìm thấy '+CAST(@COUNTS AS NVARCHAR(100))+' bản ghi';
		END
END;
DECLARE @RESULT NVARCHAR(100);
EXEC SELECT_TINH 'BD',@RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO
-- Bang SanVD
CREATE PROC INSERT_SANVD
@MASAN VARCHAR(5),
@TENSAN NVARCHAR(100),
@DIACHI NVARCHAR(200),
@RESULT NVARCHAR(100) output
AS
BEGIN
	DECLARE @COUNTS INT = 0 ;
	DECLARE @error INT;
	DECLARE @id INT;
	SELECT @COUNTS = COUNT(*) FROM SANVD WHERE SANVD.MASAN = @MASAN;
	IF @COUNTS >= 1
		SET @RESULT = N'Tồn tại mã sân ' + @MASAN;
	ELSE
		BEGIN
			INSERT INTO SANVD VALUES (@MASAN, @TENSAN, @DIACHI);
			SELECT @error = @@ERROR, @id = SCOPE_IDENTITY();
			IF @error = 0 
				SET @RESULT = N'Đã tạo dữ liệu cho mã sân là: ' + @MASAN;
			ELSE 
				SET @RESULT = N'Đã xảy ra lỗi tạo dữ liệu với mã lỗi ' +@id;
		END;
END;
DECLARE @RESULT NVARCHAR(100);
EXEC INSERT_SANVD 'LT', N'Lạch Tray', N'15 Lạch Tray, Ngô Quyền, Hải Phòng',@RESULT output;
SELECT @RESULT AS MESSAGES_RESULT;
GO

-- UPDATE_SANVD
CREATE PROCEDURE UPDATE_SANVD
    @MASAN varchar(5),
    @TENSAN nvarchar(100),
    @DIACHI nvarchar(200),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM SANVD WHERE MASAN = @MASAN;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy mã sân vận động: ' + @MASAN;
    ELSE
        BEGIN
            UPDATE SANVD SET TENSAN = @TENSAN, DIACHI = @DIACHI WHERE MASAN = @MASAN;
            SELECT @error = @@ERROR; 

            IF @error = 0
                SET @RESULT = N'Đã cập nhật thông tin cho sân vận động với mã: ' + @MASAN;
            ELSE
                SET @RESULT = N'Có lỗi xảy ra khi cập nhật thông tin cho sân vận động với mã: ' + @MASAN;
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC UPDATE_SANVD 'LT', N'Lạch Tray', N'15 Lạch Tray, Ngô Quyền, Hải Phòng', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGE_RESULT;
GO
-- DELETE_SANVD
CREATE PROCEDURE DELETE_SANVD
    @MASAN varchar(5),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM SANVD WHERE MASAN = @MASAN;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy mã sân vận động: ' + @MASAN;
    ELSE
        BEGIN
            DELETE FROM SANVD WHERE MASAN = @MASAN;
            SELECT @error = @@ERROR; 

            IF @error = 0
                SET @RESULT = N'Đã xóa thông tin cho sân vận động có mã: ' + @MASAN;
            ELSE
                PRINT N'Có lỗi xảy ra khi xóa thông tin cho sân vận động có mã: ' + @MASAN;
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC DELETE_SANVD 'GD', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGE_RESULT;
GO
-- SELECT_SANVD
CREATE PROCEDURE SELECT_SANVD
    @MASAN varchar(5),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM SANVD WHERE MASAN = @MASAN;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy thông tin cho sân vận động có mã: ' + @MASAN;
    ELSE
        BEGIN
            SELECT * FROM SANVD WHERE MASAN = @MASAN;
            SET @RESULT = N'Tìm thấy ' + CAST(@COUNT AS NVARCHAR(100)) + N' bản ghi';
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC SELECT_SANVD 'LT', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGE_RESULT;
GO

-- Bảng CAULACBO
-- INSERT_CAULACBO
CREATE PROCEDURE INSERT_CAULACBO
    @MACLB varchar(5),
    @TENCLB nvarchar(100),
    @MASAN varchar(5),
    @MATINH varchar(5),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;
    DECLARE @id int;

    SELECT @COUNT = COUNT(*) FROM CAULACBO WHERE MACLB = @MACLB;

    IF @COUNT > 0
        SET @RESULT = N'Mã câu lạc bộ đã tồn tại: ' + @MACLB;
    ELSE
        BEGIN
            SELECT @COUNT = COUNT(*) FROM SANVD WHERE MASAN = @MASAN;
            IF @COUNT = 0
                SET @RESULT = N'Mã sân vận động không tồn tại: ' + @MASAN;
            ELSE
            BEGIN
                SELECT @COUNT = COUNT(*) FROM TINH WHERE MATINH = @MATINH;
                IF @COUNT = 0
                    SET @RESULT = N'Mã tỉnh/thành phố không tồn tại: ' + @MATINH;
                ELSE
                BEGIN
                    INSERT INTO CAULACBO VALUES (@MACLB, @TENCLB, @MASAN, @MATINH);
                    SELECT @error = @@ERROR, @id = SCOPE_IDENTITY(); 

                    IF @error = 0
                        SET @RESULT = N'Đã tạo dữ liệu cho câu lạc bộ có mã: ' + @MACLB;
                    ELSE
                        SET @RESULT = N'Đã xảy ra lỗi tạo dữ liệu với mã lỗi: ' + @id;
                END;
            END;
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC INSERT_CAULACBO 'HPFC', N'Hải Phòng', 'LT', 'HPH', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO
-- UPDATE_CAULACBO
CREATE PROCEDURE UPDATE_CAULACBO
    @MACLB varchar(5),
    @TENCLB nvarchar(100),
    @MASAN varchar(5),
    @MATINH varchar(5),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM CAULACBO WHERE MACLB = @MACLB;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy mã câu lạc bộ: ' + @MACLB;
    ELSE
        BEGIN
            SELECT @COUNT = COUNT(*) FROM SANVD WHERE MASAN = @MASAN;
            IF @COUNT = 0
                SET @RESULT = N'Mã sân vận động không tồn tại: ' + @MASAN;
            ELSE
            BEGIN
                SELECT @COUNT = COUNT(*) FROM TINH WHERE MATINH = @MATINH;
                IF @COUNT = 0
                    SET @RESULT = N'Mã tỉnh/thành phố không tồn tại: ' + @MATINH;
                ELSE
                BEGIN
                    UPDATE CAULACBO SET TENCLB = @TENCLB, MASAN = @MASAN, MATINH = @MATINH WHERE MACLB = @MACLB;
                    SELECT @error = @@ERROR; 

                    IF @error = 0
                        SET @RESULT = N'Đã cập nhật thông tin cho câu lạc bộ có mã: ' + @MACLB;
                    ELSE
                        SET @RESULT = N'Đã xảy ra lỗi cập nhật';
                END;
            END;
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC UPDATE_CAULACBO 'HPFC', N'HẢI PHÒNG', 'LT', 'HPH', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

-- DELETE_CAULACBO

CREATE PROCEDURE DELETE_CAULACBO
    @MACLB varchar(5),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM CAULACBO WHERE MACLB = @MACLB;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy mã câu lạc bộ: ' + @MACLB;
    ELSE
        BEGIN
            DELETE FROM CAULACBO WHERE MACLB = @MACLB;
            SELECT @error = @@ERROR; 

            IF @error = 0
                SET @RESULT = N'Đã xóa thông tin cho câu lạc bộ có mã: ' + @MACLB;
            ELSE
                PRINT N'Đã xảy ra lỗi khi xóa thông tin cho câu lạc bộ có mã: ' + @MACLB;
        END
END;

DECLARE @RESULT NVARCHAR(100);
EXEC DELETE_CAULACBO 'GDT', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

--  SELECT_CAULACBO
CREATE PROCEDURE SELECT_CAULACBO
    @MACLB varchar(5),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM CAULACBO WHERE MACLB = @MACLB;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy mã câu lạc bộ: ' + @MACLB;
    ELSE
        BEGIN
            SELECT * FROM CAULACBO WHERE MACLB = @MACLB;
            SET @RESULT = N'Tìm thấy ' + CAST(@COUNT AS NVARCHAR(100)) + N' bản ghi';
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC SELECT_CAULACBO 'HPFC', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO
-- Bảng quốc gia
-- INSERT_QUOCGIA
CREATE PROCEDURE INSERT_QUOCGIA
    @MAQG varchar(5),
    @TENQG nvarchar(60),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;
	DECLARE @id INT;
    SELECT @COUNT = COUNT(*) FROM QUOCGIA WHERE MAQG = @MAQG;

    IF @COUNT > 0
        SET @RESULT = N'Mã quốc gia đã tồn tại: ' + @MAQG;
    ELSE
        BEGIN
            INSERT INTO QUOCGIA VALUES (@MAQG, @TENQG);
            SELECT @error = @@ERROR, @id = SCOPE_IDENTITY(); 

            IF @error = 0
                SET @RESULT = N'Đã tạo dữ liệu cho quốc gia có mã: ' + @MAQG;
            ELSE
                SET @RESULT = N'Đã xảy ra lỗi tạo dữ liệu với mã lỗi: ' + @id;
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC INSERT_QUOCGIA 'LAO', N'Lào', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

-- UPDATE_QUOCGIA
CREATE PROCEDURE UPDATE_QUOCGIA
    @MAQG varchar(5),
    @TENQG nvarchar(60),
    @RESULT nvarchar(100) OUTPUT
AS
BEGIN
    DECLARE @COUNT int;
    DECLARE @error int;

    SELECT @COUNT = COUNT(*) FROM QUOCGIA WHERE MAQG = @MAQG;

    IF @COUNT = 0
        SET @RESULT = N'Không tìm thấy mã quốc gia: ' + @MAQG;
    ELSE
        BEGIN
            UPDATE QUOCGIA SET TENQG = @TENQG WHERE MAQG = @MAQG;
            SELECT @error = @@ERROR; 

            IF @error = 0
                SET @RESULT = N'Đã cập nhật thông tin cho quốc gia có mã: ' + @MAQG;
            ELSE
                SET @RESULT = N'Đã xảy ra lỗi cập nhật';
        END;
END;

DECLARE @RESULT NVARCHAR(100);
EXEC UPDATE_QUOCGIA 'LAO', N'Lào', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

-- DELETE_QUOCGIA
CREATE PROC DELETE_QUOCGIA
@KEY VARCHAR(5),
@RESULT NVARCHAR(100) OUTPUT
AS
BEGIN
	DECLARE @COUNTS INT = 0;
	DECLARE @error INT;
	SELECT @COUNTS = COUNT(*) FROM QUOCGIA A WHERE A.MAQG = @KEY;
	IF @COUNTS = 0
		SET @RESULT = N'Không tìm thấy mã quốc gia: '+@KEY;
	ELSE
		BEGIN
			DELETE FROM QUOCGIA WHERE MAQG = @KEY;
			SELECT @error = @@ERROR; 
			IF @error = 0
				SET @RESULT = N'Đã xóa mã quốc gia: '+@KEY;
			ELSE
				PRINT 'Đã xảy ra lỗi khi xóa mã quốc gia: '+@KEY;
		END
END;

DECLARE @RESULT NVARCHAR(100);
EXEC DELETE_QUOCGIA 'LAO', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO 
-- SELECT_QUOCGIA
CREATE PROC SELECT_QUOCGIA
@KEY VARCHAR(5),
@RESULT NVARCHAR(100) OUTPUT
AS
BEGIN
	DECLARE @COUNTS INT = 0;
	DECLARE @error INT;
	SELECT @COUNTS = COUNT(*) FROM QUOCGIA A WHERE A.MAQG = @KEY;
	IF @COUNTS = 0
		SET @RESULT = N'Không tìm thấy mã quốc gia: '+@KEY;
	ELSE
		BEGIN
			SELECT * FROM QUOCGIA A WHERE A.MAQG=@KEY;
			SET @RESULT = N'Tìm thấy '+CAST(@COUNTS AS NVARCHAR(100))+N' bản ghi';
		END
END;

DECLARE @RESULT NVARCHAR(100);
EXEC SELECT_QUOCGIA 'VN', @RESULT OUTPUT;
SELECT @RESULT AS MESSAGES_RESULT;
GO

--Bài tập về Trigger
--Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cần thủ chỉ thuộc một trong các vị trí sau: Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ.
--Khi thêm cầu thủ mới, kiểm tra số áo của cầu thủ thuộc cùng một câu lạc bộ phải khác nhau.
--Khi thêm thông tin cầu thủ thì in ra câu thông báo bằng Tiếng Việt ‘ Đã thêm cầu thủ mới’.
--Khi thêm cầu thủ mới, kiểm tra số lượng cầu thủ nước ngoài ở mỗi câu lạc bộ chỉ được phép đăng ký tối đa 8 cầu thủ.

CREATE TRIGGER TRIG_CAUTHU ON CAUTHU
FOR INSERT
AS
	DECLARE @HOTEN NVARCHAR(100);
	DECLARE @VITRI NVARCHAR(50);
	DECLARE @NGAYSINH DATE;
	DECLARE @DIACHI NVARCHAR(200);
	DECLARE @MACLB VARCHAR(5);
	DECLARE @MAQG VARCHAR (5);
	DECLARE @SO INT;
BEGIN
	-- Lấy thông tin dữ liệu đầu vào và set giá trị vào biến.
	SELECT @HOTEN = a.HOTEN, @VITRI = a.VITRI, @NGAYSINH =a.NGAYSINH, 
	@DIACHI =a.DIACHI, @MACLB =a.MACLB,@MAQG =a.MAQG,@SO=a.SO FROM INSERTED a;

	IF (@VITRI = N'Thủ môn' OR  
	@VITRI = N'Tiền Đạo' OR   
	@VITRI = N'Tiền vệ' OR 
	@VITRI = N'Trung vệ' OR 
	@VITRI = N'Hậu vệ' )
		BEGIN
			DECLARE @SO_LUONG INT;
			-- kiểm tra số áo
			SELECT @SO_LUONG = COUNT(*) FROM CAUTHU A WHERE A.SO=@SO AND A.MACLB=@MACLB;
			IF @SO_LUONG = 0
				BEGIN
					DECLARE @CAU_THU_NUOC_NGOAI INT;
					-- kiểm tra số lượng cầu thủ nước ngoài ở mỗi câu lạc bộ chỉ được phép đăng ký tối đa 8 cầu thủ.
					SELECT @CAU_THU_NUOC_NGOAI = COUNT(*) FROM CAUTHU C JOIN CAULACBO B ON C.MACLB = B.MACLB
					WHERE C.MACLB=@MACLB AND C.MAQG <> 'VN';

					IF  @CAU_THU_NUOC_NGOAI <= 8
						BEGIN
							DECLARE @error INT;
							INSERT INTO CAUTHU VALUES (@HOTEN,@VITRI,@NGAYSINH,@DIACHI,@MACLB,@MAQG,@SO);
							SELECT @error = @@ERROR; 
							IF @error = 0
								BEGIN
									COMMIT TRANSACTION;
									PRINT N'Đã thêm cầu thủ mới';
								END
							ELSE
								BEGIN
									PRINT N'Xảy ra lỗi khi thêm cầu thủ mới';
									ROLLBACK TRANSACTION;
								END
						END
					ELSE
						BEGIN
							PRINT N'SỐ LƯỢNG CẦU THỦ NGOẠI QUỐC VƯỢT QUÁ 8';
							ROLLBACK TRANSACTION;
						END
				END
			ELSE
				BEGIN
					PRINT N'ĐÃ TỒN TẠI SỐ ÁO: '+CAST(@SO AS NVARCHAR(100));
					ROLLBACK TRANSACTION;
				END
		END
	ELSE
		BEGIN
			PRINT N'KHÔNG THUỘC VỊ TRÍ NÀO';
			ROLLBACK TRANSACTION;
		END
END;
INSERT INTO CAUTHU VALUES (N'Nguyễn Công Sơn',N'Tiền đạo','1990-02-20',NULL,'BBD','VN',10);
GO
--Khi thêm tên quốc gia, kiểm tra tên quốc gia không được trùng với tên quốc gia đã có.
CREATE TRIGGER TRIG_QUOCGIA ON QUOCGIA
FOR INSERT
AS
	DECLARE @MAQG VARCHAR(5);
	DECLARE @TENQG NVARCHAR(60);
BEGIN
	SELECT @MAQG = A.MAQG, @TENQG = A.TENQG FROM INSERTED A;
	IF((SELECT COUNT(*) FROM QUOCGIA QG WHERE QG.TENQG =@TENQG) = 0)
		BEGIN
			DECLARE @error INT;
			INSERT INTO QUOCGIA VALUES (@MAQG, @TENQG);
			SELECT @error = @@ERROR; 
			IF @error = 0
				BEGIN
					COMMIT TRANSACTION;
					PRINT N'Đã thêm quốc gia';
				END
			ELSE
				BEGIN
					PRINT N'Xảy ra lỗi khi thêm quốc gia';
					ROLLBACK TRANSACTION;
				END
		END
	ELSE
		BEGIN 
			PRINT N'TÊN QUỐC GIA ĐÃ TỒN TẠI';
			ROLLBACK TRANSACTION;
		END
END;
GO
--Khi thêm tên tỉnh thành, kiểm tra tên tỉnh thành không được trùng với tên tỉnh thành đã có.
CREATE TRIGGER TRIG_TINH ON TINH
FOR INSERT
AS
	DECLARE @MATINH VARCHAR(5);
	DECLARE @TENTINH NVARCHAR(100);
BEGIN
	SELECT @MATINH = A.MATINH, @TENTINH = A.TENTINH FROM INSERTED A;
	IF((SELECT COUNT(*) FROM TINH T WHERE T.TENTINH =@TENTINH) = 0)
		BEGIN
			DECLARE @error INT;
			INSERT INTO TINH VALUES (@MATINH, @TENTINH);
			SELECT @error = @@ERROR; 
			IF @error = 0
				BEGIN
					COMMIT TRANSACTION;
					PRINT N'Đã thêm TỈNH';
				END
			ELSE
				BEGIN
					PRINT N'Xảy ra lỗi khi thêm TỈNH';
					ROLLBACK TRANSACTION;
				END
		END
	ELSE
		BEGIN 
			PRINT N'TÊN TỈNH ĐÃ TỒN TẠI';
			ROLLBACK TRANSACTION;
		END
END;
GO
--Không cho sửa kết quả của các trận đã diễn ra.

CREATE TRIGGER TRIG_TRANDAU ON TRANDAU
FOR UPDATE
AS
BEGIN
	DECLARE	@KETQUA1 VARCHAR(5)
	DECLARE	@KETQUA2 VARCHAR(5)
	Select @KETQUA1 = I.KETQUA, @KETQUA2 = d.KETQUA from inserted i join deleted d on (i.MATRAN = d.MATRAN);
	IF (@KETQUA1 <> @KETQUA2)
		BEGIN
			PRINT N'KHÔNG ĐƯỢC CHỈNH SỬA KẾT QUẢ CỦA TRẬN ĐẤU';
			ROLLBACK TRANSACTION;
		END
END;
UPDATE TRANDAU SET KETQUA='3-1' WHERE MATRAN=1;
GO
--Khi phân công huấn luyện viên cho câu lạc bộ:
--Kiểm tra vai trò của huấn luyện viên chỉ thuộc một trong các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn .
--Kiểm tra mỗi câu lạc bộ chỉ có tối đa 2 HLV chính.
CREATE TRIGGER TRIG_HLV_CLB ON HLV_CLB
FOR INSERT
AS
	DECLARE @MACLB VARCHAR(5);
	DECLARE @MAHLV VARCHAR(5);
	DECLARE @VAITRO NVARCHAR(10);
BEGIN
	SELECT @MACLB = A.MACLB, @MAHLV = A.MAHLV,@VAITRO = A.VAITRO FROM INSERTED A;
	IF (@VAITRO = 'HLV chính' OR
		@VAITRO = 'HLV phụ' OR
		@VAITRO = 'HLV thể lực' OR
		@VAITRO = 'HLV thủ môn')
		IF((SELECT COUNT(*) FROM CAULACBO A JOIN HLV_CLB B ON A.MACLB = B.MACLB 
		WHERE A.MACLB=@MACLB AND B.VAITRO=N'HLV chính') = 0)
			BEGIN 
				DECLARE @error INT;
				INSERT INTO HLV_CLB VALUES (@MAHLV, @MACLB, @VAITRO);
				SELECT @error = @@ERROR; 
				IF @error = 0
					BEGIN
						COMMIT TRANSACTION;
						PRINT N'Đã phân công';
					END
				ELSE
					BEGIN
						PRINT N'Xảy ra lỗi khi phân công';
						ROLLBACK TRANSACTION;
					END
			END
		ELSE
			BEGIN
				PRINT 'mỗi câu lạc bộ chỉ có tối đa 2 HLV chính.';
				ROLLBACK TRANSACTION;
			END
	ELSE
		BEGIN
			PRINT N'Vai trò của huấn luyện viên không thuộc trong các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn';
			ROLLBACK TRANSACTION;
		END
END
GO
--Khi thêm mới một câu lạc bộ thì kiểm tra xem đã có câu lạc bộ trùng tên với câu lạc bộ vừa được thêm hay không?
--chỉ thông báo vẫn cho insert.
--thông báo và không cho insert.
CREATE TRIGGER TRIG_CAULACBO ON CAULACBO
FOR INSERT
AS
	DECLARE @MACLB VARCHAR(5);
	DECLARE @TENCLB NVARCHAR(100);
	DECLARE @MASAN VARCHAR(5);
	DECLARE @MATINH VARCHAR(5);
BEGIN
	SELECT @TENCLB = A.TENCLB FROM INSERTED A;
	BEGIN
		IF((SELECT COUNT(*) FROM CAULACBO A WHERE A.TENCLB=@TENCLB) > 0)
			PRINT N'TRÙNG TÊN CÂU LẠC BỘ VÀ TẠO BẢN GHI MỚI';
	END
		INSERT INTO CAULACBO VALUES (@MACLB, @TENCLB, @MASAN, @MATINH);
		COMMIT TRANSACTION;
END;
GO

CREATE TRIGGER TRIG_CAULACBO ON CAULACBO
FOR INSERT
AS
	DECLARE @MACLB VARCHAR(5);
	DECLARE @TENCLB NVARCHAR(100);
	DECLARE @MASAN VARCHAR(5);
	DECLARE @MATINH VARCHAR(5);
BEGIN
	SELECT @TENCLB = A.TENCLB FROM INSERTED A;
	IF((SELECT COUNT(*) FROM CAULACBO A WHERE A.TENCLB=@TENCLB) = 0)
		BEGIN
			INSERT INTO CAULACBO VALUES (@MACLB, @TENCLB, @MASAN, @MATINH);
			DECLARE @error INT;
			SELECT @error = @@ERROR; 
			IF @error = 0
				BEGIN
					COMMIT TRANSACTION;
					PRINT N'Đã tạo bản ghi';
				END
			ELSE
				BEGIN
					PRINT N'Xảy ra lỗi khi tạo mới';
					ROLLBACK TRANSACTION;
				END
		END
	ELSE
		PRINT  N'TRÙNG TÊN CÂU LẠC BỘ, ROLLBACK TRANSACTION';
END
GO
--Khi sửa tên cầu thủ cho một (hoặc nhiều) cầu thủ thì in ra:
--danh sách mã cầu thủ của các cầu thủ vừa được sửa.
--danh sách mã cầu thủ vừa được sửa và tên cầu thủ mới.
--danh sách mã cầu thủ vừa được sửa và tên cầu thủ cũ.
--danh sách mã cầu thủ vừa được sửa và tên cầu thủ cũ và cầu thủ mới.
--câu thông báo bằng Tiếng Việt:
--Vừa sửa thông tin của cầu thủ có mã số xxx’ với xxx là mã cầu thủ vừa được sửa.

CREATE TRIGGER TRIG_CAUTHU_UPDATE ON CAUTHU
FOR UPDATE
AS
	DECLARE @MACT INT;
	DECLARE @HOTEN_NEW NVARCHAR(100);
	DECLARE @HOTEN_OLD NVARCHAR(100);
BEGIN
	Select @MACT = I.MACT,@HOTEN_NEW = I.HOTEN, @HOTEN_OLD = D.HOTEN from inserted i join deleted d on (i.MACT = d.MACT);
	UPDATE CAUTHU SET HOTEN = @HOTEN_NEW WHERE MACT=@MACT;
	PRINT @MACT;
	PRINT CAST(@MACT AS NVARCHAR(10)) +' - '+ @HOTEN_NEW;
	PRINT CAST(@MACT AS NVARCHAR(10)) +' - '+ @HOTEN_OLD;
	PRINT CAST(@MACT AS NVARCHAR(10)) +' - '+ @HOTEN_OLD +' - '+  @HOTEN_NEW;
	PRINT N'Vừa sửa thông tin của cầu thủ có mã số '+CAST(@MACT AS NVARCHAR(10));
END
UPDATE CAUTHU SET HOTEN=N'Nguyễn Công Sơn' where MACT=1;


