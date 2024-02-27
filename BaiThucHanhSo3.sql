--a. Xử lý chuỗi ngày giờ
-- 1.  Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn 
-- ra vào tháng 3 trên sân nhà mà không bị thủng lưới.

SELECT NGAYTD, CLB1.TENCLB, CLB2.TENCLB, KETQUA
FROM TRANDAU, CAULACBO AS CLB1, CAULACBO AS CLB2
WHERE TRANDAU.MACLB1 =  CLB1.MACLB 
AND TRANDAU.MACLB2 =  CLB2.MACLB 
AND (( TRANDAU.MASAN = CLB1.MASAN AND KETQUA LIKE '0%')
OR ( TRANDAU.MASAN = CLB2.MASAN AND KETQUA LIKE '%0'))
AND MONTH(TRANDAU.NGAYTD) = 3;


--2. Cho biết mã số, họ tên, 
--ngày sinh của những cầu thủ có họ lót là “Công”
SELECT HOTEN, MACT, NGAYSINH 
FROM CAUTHU 
WHERE HOTEN LIKE N'%Công%';

--3. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có
-- họ không phải là họ “Nguyễn “.

SELECT HOTEN, MACT, NGAYSINH
FROM CAUTHU
WHERE HOTEN NOT LIKE N'Nguyễn%';

-- 4. Cho biết mã huấn luyện viên, họ tên, ngày sinh, 
--địa chỉ của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35-40.

SELECT MAHLV, TENHLV, NGAYSINH, DIACHI
FROM HUANLUYENVIEN
WHERE MAQG = (SELECT MAQG FROM QUOCGIA
				WHERE TENQG LIKE N'Việt Nam')
AND  (YEAR(GETDATE())- YEAR(NGAYSINH))>= 35
AND  (YEAR(GETDATE())- YEAR(NGAYSINH)) <= 40;

-- Cach 2

SELECT MAHLV, TENHLV,NGAYSINH,DIACHI
FROM HUANLUYENVIEN AS HLV
WHERE (YEAR(GETDATE()) - YEAR(NGAYSINH)) BETWEEN 35 AND 40;

--5

SELECT TENCLB
FROM CAULACBO AS CLB, HLV_CLB, HUANLUYENVIEN AS HLV
WHERE CLB.MACLB = HLV_CLB.MACLB
AND HLV_CLB.MAHLV = HLV.MAHLV
AND HLV.NGAYSINH = '1970-06-10';

--6.  Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có số bàn thắng 
-- nhiều nhất tính đến hết vòng 3 năm 2009.


SELECT TOP 1  TENCLB, TENTINH , 
CONVERT(INT, SUBSTRING(HIEUSO,1, CHARINDEX('-', HIEUSO)-1)) "Số bàn thắng"
FROM CAULACBO AS CLB, TINH, BANGXH
WHERE CLB.MATINH = TINH.MATINH
AND BANGXH.MACLB = CLB.MACLB
AND VONG = 3 
ORDER BY "Số bàn thắng" DESC;


-- b Truy vấn con
-- 1. . Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, 
-- địa chỉ và số lượng cầu thủ nước ngoài (Có quốc tịch khác “Việt Nam”) 
-- tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.


SELECT CLB.MACLB, TENCLB, SANVD.TENSAN, SANVD.DIACHI, COUNT (MACT) "Số lượng cầu thủ nước ngoài"
FROM CAULACBO AS CLB, SANVD, CAUTHU
WHERE CLB.MASAN=  SANVD.MASAN
AND CAUTHU.MACLB = CLB.MACLB 
AND MAQG  NOT LIKE (SELECT MAQG FROM QUOCGIA 
					WHERE TENQG LIKE N'Việt Nam')

GROUP BY CLB.MACLB, CLB.TENCLB, SANVD.TENSAN,SANVD.DIACHI
HAVING COUNT (MACT) >= 2 ;

-- 2. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng
-- bại cao nhất năm 2009

SELECT  TOP 1 TENCLB, TENTINH,
CONVERT(INT, SUBSTRING(HIEUSO,1, CHARINDEX('-', HIEUSO)-1)) - CONVERT(INT, SUBSTRING(HIEUSO, CHARINDEX('-', HIEUSO)+1, LEN(HIEUSO))) 
"Hiệu số thắng thua"
FROM CAULACBO AS CLB , BANGXH, TINH
WHERE CLB.MACLB = BANGXH.MACLB
AND CLB.MATINH = TINH.MATINH
AND VONG = 4
ORDER BY "Hiệu số thắng thua" DESC;

-- 3. Cho biết danh sách các trận đấu ( NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009.

SELECT NGAYTD, CLB1.TENCLB, CLB2.TENCLB, KETQUA
FROM TRANDAU, CAULACBO AS CLB1, CAULACBO AS CLB2
WHERE TRANDAU.MACLB1 = CLB1.MACLB
AND TRANDAU.MACLB2 = CLB2.MACLB
AND (TRANDAU.MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH
                    WHERE VONG = 3
                    ORDER BY HANG DESC)
OR TRANDAU.MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH
                    WHERE VONG = 3
                    ORDER BY HANG DESC));

-- 4    Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi 
-- đấu với tất cả các câu lạc bộ còn lại (kể cả sân nhà và sân khách) trong mùa giải năm 2009.                
      
SELECT MACLB , TENCLB
FROM CAULACBO
WHERE (SELECT COUNT(DISTINCT MACLB2)
        FROM TRANDAU
        WHERE MACLB1=MACLB) 
        + 
        (SELECT COUNT(DISTINCT MACLB1)
        FROM TRANDAU
        WHERE MACLB2=MACLB) 
        = (SELECT COUNT(MACLB) FROM CAULACBO)-1;

--  5. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với
-- tất cả các câu lạc bộ còn lại ( chỉ tính sân nhà) tro ng mùa giải năm 2009.
SELECT MACLB , TENCLB
FROM CAULACBO
WHERE (SELECT COUNT(DISTINCT MACLB2)
        FROM TRANDAU
        WHERE MACLB1=MACLB) 
        = (SELECT COUNT(MACLB) FROM CAULACBO)-1;


-- c. Bài tập về Rule
-- 1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong các vị trí sau:
--  Thủ môn, tiền đạo, tiền vệ, trung vệ, hậu vệ.
ALTER TABLE CAUTHU
ADD CONSTRAINT CK_VITRI_CAUTHU CHECK (VITRI IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ'));


-- 2. Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện viên chỉ thuộc
--  một trong các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn.
ALTER TABLE HLV_CLB
ADD CONSTRAINT CK_VAITRO_HLV CHECK (VAITRO IN(N'HLV chính', N'HLV phụ', N'HLV thể lực', N'HLV thủ môn'));

-- 3. Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm sinh)
ALTER TABLE CAUTHU
ADD CONSTRAINT CK_AGE_CT CHECK (YEAR(GETDATE())-DATEPART(YEAR, NGAYSINH) > 18);


-- 4.  Kiểm tra kết quả trận đấu có dạng số_bàn_thắng- số_bàn_thua
ALTER TABLE TRANDAU 
ADD CONSTRAINT CK_KQ_FORMAT CHECK (KETQUA LIKE '%-%');
GO
-- d) Bài  tập về View
-- 1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bón g “SHB
-- Đà Nẵng” có quốc tịch “Bra-xin”

CREATE VIEW view_1 AS
SELECT MACT, HOTEN, NGAYSINH, DIACHI
FROM CAUTHU
WHERE MAQG = (SELECT MAQG FROM QUOCGIA
                WHERE TENQG = 'Bra-xin')
AND MACLB = (SELECT MACLB FROM CAULACBO
                WHERE TENCLB = N'SHB ĐÀ NẴNG');
GO
-- 2.2. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận
-- đấu vòng 3 của mùa bóng năm 2009.
CREATE VIEW view_2 AS
SELECT MATRAN, NGAYTD, TENSAN, CLB1.TENCLB AS CLB1, CLB2.TENCLB AS CLB2, KETQUA
FROM TRANDAU, SANVD, CAULACBO AS CLB1 , CAULACBO AS CLB2
WHERE TRANDAU.MASAN = SANVD.MASAN
AND TRANDAU.MACLB1 = CLB1.MACLB
AND TRANDAU.MACLB2 = CLB2.MACLB;
GO

-- 3. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc
-- của các huấn luyện viên có quốc tịch “Việt Nam”
CREATE VIEW view_3 AS
SELECT HUANLUYENVIEN.MAHLV, TENHLV, NGAYSINH, DIACHI, VAITRO
FROM HUANLUYENVIEN, HLV_CLB, CAULACBO
WHERE HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
AND HLV_CLB.MACLB = CAULACBO.MACLB
AND MAQG = (SELECT MAQG FROM QUOCGIA
                WHERE TENQG = N'Việt Nam');
GO

-- 4. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ 
-- và số lượng cầu thủ nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng
--  của các câu lạc bộ nhiều hơn 2 cầu thủ nước ngoài
CREATE VIEW view_4 AS
SELECT CLB.MACLB, TENCLB, TENSAN, SANVD.DIACHI , COUNT(MACT) "SL cầu thủ nước ngoài"
FROM CAULACBO AS CLB, SANVD, CAUTHU
WHERE CLB.MASAN = SANVD.MASAN
AND CAUTHU.MACLB = CLB.MACLB
AND CAUTHU.MAQG NOT LIKE (SELECT MAQG FROM QUOCGIA 
                        WHERE TENQG = N'Việt Nam')
GROUP BY CLB.MACLB, TENCLB, SANVD.TENSAN, SANVD.DIACHI
HAVING COUNT(MACT) >= 2;
GO

-- 5. Cho biết tên tỉnh, số lượng câu thủ đang thi đấu ở vị trí tiền đạo 
-- trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý.

CREATE VIEW view_5 AS
SELECT TENTINH, COUNT (MACT) "Số lượng cầu thủ"
FROM TINH, CAULACBO, CAUTHU
WHERE CAULACBO.MATINH = TINH.MATINH
AND CAUTHU.MACLB = CAULACBO.MACLB
AND CAUTHU.VITRI = N'Tiền đạo'
GROUP BY TENTINH;
GO

-- 6. Cho biết tên câu lạc bộ,tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất 
-- của bảng xếp hạng của vòng 3 năm 2009
CREATE VIEW view_6 AS
SELECT TENCLB, TENTINH
FROM CAULACBO, TINH, BANGXH
WHERE CAULACBO.MATINH = TINH.MATINH
AND BANGXH.MACLB = CAULACBO.MACLB
AND VONG = 3
AND HANG = 1;
GO
-- 7. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong 1 c âu lạc bộ 
-- mà chưa có số điện thoại

CREATE VIEW view_7 AS
SELECT TENHLV
FROM HUANLUYENVIEN, HLV_CLB
WHERE HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
AND DIENTHOAI IS NULL;
GO

-- 8. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam 
-- chưa làm công tác huấn luyện tại bất kỳ một câu lạc b ộ nào

CREATE VIEW view_8 AS
SELECT MAHLV, TENHLV
FROM HUANLUYENVIEN
WHERE MAQG = (SELECT MAQG FROM QUOCGIA 
                WHERE TENQG = N'Việt Nam')
AND MAHLV NOT IN (SELECT MAHLV FROM HLV_CLB);
GO

-- 9. Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG,
-- SOBANTHANG,SOBANTHUA)
CREATE VIEW view_9 AS
SELECT MACLB1, MACLB2, NAM, VONG,
LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) "Số bàn thắng",
RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA)) "Số bàn thua" 
FROM TRANDAU;
GO

-- 10. Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG,
-- SOBANTHANG, SOBANTHUA)
CREATE VIEW view_10 AS
SELECT CAULACBO.MACLB, NAM, VONG,
LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) "Số bàn thắng",
RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA)) "Số bàn thua" 
FROM CAULACBO, TRANDAU
WHERE TRANDAU.MACLB1 = CAULACBO.MACLB
AND TRANDAU.MASAN = CAULACBO.MASAN;
GO

-- 11. Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG,
-- SOBANTHANG,SOBANTHUA)
CREATE VIEW view_11 AS
SELECT CAULACBO.MACLB, NAM, VONG,
LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) "Số bàn thắng",
RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA)) "Số bàn thua" 
FROM CAULACBO, TRANDAU
WHERE TRANDAU.MACLB2 = CAULACBO.MACLB
AND TRANDAU.MASAN = CAULACBO.MASAN;
GO

-- 12. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009

CREATE VIEW view_12 AS
SELECT NGAYTD, TENSAN, CLB1.TENCLB "Tên CLB1", CLB2.TENCLB "Tên CLB2"
FROM TRANDAU, CAULACBO AS CLB1, CAULACBO AS CLB2, SANVD
WHERE TRANDAU.MASAN = SANVD.MASAN
AND TRANDAU.MACLB1 = CLB1.MACLB
AND TRANDAU.MACLB2 = CLB2.MACLB
AND (SELECT MACLB FROM BANGXH
                        WHERE VONG = 3 
                        AND HANG = 1) IN (TRANDAU.MACLB1, TRANDAU.MACLB2);
GO

-- 13. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
CREATE VIEW view_13 AS
SELECT NGAYTD, TENSAN, CLB1.TENCLB "Tên CLB1", CLB2.TENCLB "Tên CLB2"
FROM TRANDAU, CAULACBO AS CLB1, CAULACBO AS CLB2, SANVD
WHERE TRANDAU.MASAN = SANVD.MASAN
AND TRANDAU.MACLB1 = CLB1.MACLB
AND TRANDAU.MACLB2 = CLB2.MACLB
AND (SELECT MACLB FROM BANGXH
                        WHERE VONG = 3 
                        AND HANG = (SELECT MAX(HANG) FROM BANGXH))  IN (TRANDAU.MACLB1, TRANDAU.MACLB2);
GO