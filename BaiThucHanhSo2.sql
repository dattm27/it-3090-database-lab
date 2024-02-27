
-- Trần Mạnh Đạt - 20210159 - 727623 Kíp 1 sáng T3
-- a. Truy van co ban
-- 1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) 
-- của tất cả các cầu thủ’
SELECT MACT, HOTEN, SO, VITRI, NGAYSINH, DIACHI
FROM CAUTHU;

--2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ.
SELECT MACT, HOTEN, SO, VITRI, NGAYSINH, DIACHI FROM CAUTHU
WHERE SO = 7 AND VITRI LIKE N'%Tiền vệ%';

-- 3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên.
SELECT TENHLV, NGAYSINH, DIACHI, DIENTHOAI
FROM HUANLUYENVIEN;

-- 4.Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ
-- Becamex Bình Dương
SELECT MACT, HOTEN, SO, VITRI, NGAYSINH, DIACHI FROM CAUTHU
WHERE MAQG = (SELECT MAQG FROM QUOCGIA 
			 WHERE TENQG LIKE N'%Việt Nam%')
AND MACLB = (SELECT MACLB FROM CAULACBO
			WHERE TENCLB LIKE N'%BECAMEX BÌNH DƯƠNG%');


			
SELECT * FROM CAULACBO;
-- 5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí 
-- của các cầu thủ thuộc đội bóng ‘SHB Đà Nẵng’ có quốc tịch “Bra-xin”
SELECT MACT, HOTEN, NGAYSINH, DIACHI, VITRI FROM CAUTHU
WHERE MACLB = (SELECT MACLB FROM CAULACBO 
			  WHERE TENCLB LIKE N'%SHB ĐÀ NẴNG%')
AND MAQG = (SELECT MAQG FROM QUOCGIA
		   WHERE TENQG LIKE N'%Bra-xin%');
		   
-- 6. Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ 
-- có sân nhà là “Long An”
SELECT * FROM CAUTHU
WHERE MACLB = (SELECT MACLB FROM CAULACBO
			  WHERE MASAN = (SELECT MASAN FROM SANVD
							WHERE TENSAN LIKE N'%Long An%' ));
-- 7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- các trận đấu vòng 2 của mùa bóng năm 2009
SELECT MATRAN, NGAYTD, TENSAN, CLB1.TENCLB, CLB2.TENCLB, KETQUA 
FROM TRANDAU, SANVD, CAULACBO AS CLB1, CAULACBO AS CLB2
WHERE TRANDAU.MASAN = SANVD.MASAN 
AND TRANDAU.MACLB1 = CLB1.MACLB
AND TRANDAU.MACLB2 = CLB2.MACLB
AND VONG = 2
ORDER BY MATRAN ASC;

-- 8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên 
-- CLB đang làm veiecj của các huấn luyện viên có quốc tịch “ViệtNam”
SELECT HLV.MAHLV, NGAYSINH, DIACHI, VAITRO, CLB.TENCLB
FROM HUANLUYENVIEN AS HLV, HLV_CLB, CAULACBO AS CLB
WHERE  HLV.MAHLV = HLV_CLB.MAHLV
AND HLV_CLB.MACLB = CLB.MACLB
AND MAQG = (SELECT MAQG FROM QUOCGIA
		   WHERE TENQG LIKE N'%Việt Nam%');
			
-- 9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009
SELECT TOP 3 CLB.TENCLB
FROM CAULACBO AS CLB, BANGXH 
WHERE CLB.MACLB = BANGXH.MACLB
AND VONG = 3 
ORDER BY BANGXH.DIEM DESC;


-- 10. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và 
-- tên CLB đang làm việc mà câu lạc bộ đó đóng ở tỉnh Binh Dương.

SELECT HLV.MAHLV, TENHLV, NGAYSINH, DIACHI, HLV_CLB.VAITRO, CLB.TENCLB
FROM HUANLUYENVIEN AS HLV, CAULACBO AS CLB, TINH, HLV_CLB
WHERE HLV.MAHLV = HLV_CLB.MAHLV
AND HLV_CLB.MACLB = CLB.MACLB
AND CLB.MATINH = TINH.MATINH
AND TENTINH LIKE N'%Bình Dương%';

-- b. Các phép toán trên nhóm
-- 1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ
select TENCLB , count(MACT)as "Số lượng cẩu thủ"
from CAULACBO AS clb,CAUTHU AS ct
where clb.MACLB = ct.MACLB
group by TENCLB;

-- 2. Thống kê số lượng cầu thủ nước ngoài (có quốc tịch Việt Nam) 
-- của mỗi câu lạc bộ
SELECT TENCLB, COUNT (MACT) AS "Số lượng cầu thủ nước ngoài"
FROM CAULACBO AS CLB, CAUTHU AS CT, QUOCGIA
WHERE CLB.MACLB = CT.MACLB AND CT.MAQG = QUOCGIA.MAQG
AND CT.MAQG <> (SELECT MAQG FROM QUOCGIA
			   	WHERE TENQG = N'Việt Nam')
GROUP BY TENCLB;

-- 3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng
-- cầu thủ nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các CLB có nhiều 
-- hơn 2 cầu thủ nước ngoài
SELECT  CLB.MACLB , TENCLB, TENSAN, SANVD.DIACHI,
COUNT (MACT) AS "Số lượng cầu thủ nước ngoài"
FROM CAULACBO AS CLB, CAUTHU AS CT, QUOCGIA, SANVD
WHERE CLB.MACLB = CT.MACLB AND CT.MAQG = QUOCGIA.MAQG 
AND CLB.MASAN = SANVD.MASAN
AND CT.MAQG <> (SELECT MAQG FROM QUOCGIA
			   	WHERE TENQG = N'Việt Nam')
GROUP BY TENCLB, CLB.MACLB, TENSAN, SANVD.DIACHI
HAVING COUNT (MACT) >= 2;

-- 4. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo
-- trong các Câu lạc bộ thuộc địa bàn tỉnh đó quản lí 
SELECT TENTINH, COUNT (MACT) "Số Tiền Đạo"
FROM CAULACBO AS CLB, CAUTHU AS CT, TINH 
WHERE CT.MACLB = CLB.MACLB
AND CLB.MATINH = TINH.MATINH
AND CT.VITRI = N'Tiền đạo'
GROUP BY TINH.TENTINH;

-- 5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đó đang đóng
--  nằm ở vị trí cao nhất của bảng xếp hạng vòng 3 năm 2009
SELECT TOP 1 TENCLB, TENTINH 
FROM CAULACBO AS CLB, TINH, BANGXH
WHERE CLB.MATINH = TINH.MATINH
AND VONG = 3;

-- c. Các toán tử nâng cao
-- 1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà
-- chưa có số điện thoại
SELECT TENHLV
FROM HUANLUYENVIEN
WHERE MAHLV IN (SELECT MAHLV FROM HLV_CLB)
AND DIENTHOAI IS NULL
;
-- 2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện
-- tại bất kỳ một câu lạc bộ nào
SELECT TENHLV
FROM HUANLUYENVIEN
WHERE MAQG = (SELECT MAQG FROM QUOCGIA 
			  WHERE TENQG LIKE N'Việt Nam')
AND MAHLV NOT IN (SELECT MAHLV FROM HLV_CLB);

-- 3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ
--  có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3
SELECT HOTEN , TENCLB, HANG
FROM CAUTHU, CAULACBO AS CLB, BANGXH
WHERE CAUTHU.MACLB = CLB.MACLB
AND CLB.MACLB = BANGXH.MACLB
AND VONG = 3
AND (HANG > 6 OR HANG < 3) 
ORDER BY HANG;

-- 4. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009 .
SELECT NGAYTD, TENSAN, CLB1.TENCLB, CLB2.TENCLB, KETQUA
FROM TRANDAU, SANVD, CAULACBO AS CLB1, CAULACBO AS CLB2
WHERE TRANDAU.MASAN = SANVD.MASAN
AND TRANDAU.MACLB1 = CLB1.MACLB
AND TRANDAU.MACLB2 = CLB2.MACLB
AND (CLB1.MACLB = (SELECT MACLB FROM BANGXH 
					WHERE VONG = 3
					AND HANG = 1)

	OR CLB2.MACLB = (SELECT MACLB FROM BANGXH 
					WHERE VONG = 3
					AND HANG = 1)
	);

