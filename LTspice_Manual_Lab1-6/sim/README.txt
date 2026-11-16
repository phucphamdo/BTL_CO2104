THƯ MỤC FILE MÔ PHỎNG LTSPICE - DÀNH CHO GIẢNG VIÊN / NHÓM BIÊN SOẠN
====================================================================
Lab1 ... Lab6/ExNN.cir, AdvNN.cir : NETLIST SPICE (Ex03a/Ex03b... = hai mạch con của cùng một bài) định nghĩa mạch của từng bài (chưa phải .asc).

Cách dùng:
 1. LTspice -> File -> Open -> chọn file .cir (LTspice chạy được trực tiếp netlist).
 2. Để có file .asc và ảnh chụp sơ đồ: vẽ lại mạch trong LTspice theo netlist (hoặc theo hình đề),
    lưu thành Lab1/ExNN.asc rồi chụp màn hình bỏ vào images/ của tài liệu.
 3. Lab1/Ex08 và Lab1/Ex09 là bản đã thay phần tử chưa biết bằng điện trở / nguồn DC (có chứa đáp án) -> chỉ dành cho giảng viên.

Lưu ý: các netlist CHƯA được chạy thử trên LTspice (môi trường soạn không có LTspice).
Mọi số liệu trong tài liệu và lời giải phải lấy từ lần chạy thật của nhóm.
Cú pháp .meas / .step / .dc ở Adv01, Adv02 cần được nhóm xác nhận trên phiên bản LTspice đang dùng.

Lab 4: các netlist dùng mô hình op-amp hành vi (.subckt OPAMP, nguồn B-source có limit()) để chạy độc lập;
       trong tài liệu sinh viên dùng symbol UniversalOpAmp2 -> nhóm cần xác nhận symbol này có trong bộ cài offline.
Lab 2/Ex10 (buck converter) thay cho bài LM2596 vì mô hình hãng không đảm bảo có sẵn; Lab 3/Ex10 (opto) dùng mô hình hành vi thay PC817.
Mô hình diode, BJT, JFET, MOSFET khai báo bằng .model trong từng file nên không cần thư viện ngoài.
