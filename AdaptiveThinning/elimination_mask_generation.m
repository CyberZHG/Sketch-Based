code = zeros(12, 1);

mask_2_1 = [1 0 0; 
            1 0 1; 
            1 1 1];
mask_2_2 = [1 1 0; 
            1 0 0; 
            1 1 1];
for k = 1 : 4
    code(k * 2 - 1) = elimination_mask_encoding(mask_2_1);
    code(k * 2) = elimination_mask_encoding(mask_2_2);
    mask_2_1 = rot90(mask_2_1);
    mask_2_2 = rot90(mask_2_2);
end
mask_2 = code(1 : 8);

mask_3_1 = [0 0 0;
            1 0 1;
            1 1 1];
mask_3_2 = [1 0 0;
            1 0 0;
            1 1 1];
for k = 1 : 4
    code(k * 2 - 1) = elimination_mask_encoding(mask_3_1);
    code(k * 2) = elimination_mask_encoding(mask_3_2);
    mask_3_1 = rot90(mask_3_1);
    mask_3_2 = rot90(mask_3_2);
end
mask_3_3 = [1 0 1;
            0 0 1;
            0 1 1];
mask_3_4 = [1 0 0;
            0 0 1;
            1 1 1];
code(9) = elimination_mask_encoding(mask_3_3);
code(10) = elimination_mask_encoding(mask_3_4);
code(11) = elimination_mask_encoding(rot90(mask_3_3));
code(12) = elimination_mask_encoding(rot90(mask_3_4));
mask_3 = code(1 : 12);

mask_4_1 = [0 0 0;
            1 0 0;
            1 1 1];
mask_4_2 = [1 0 0;
            1 0 0;
            1 1 0];
for k = 1 : 4
    code(k * 2 - 1) = elimination_mask_encoding(mask_4_1);
    code(k * 2) = elimination_mask_encoding(mask_4_2);
    mask_4_1 = rot90(mask_4_1);
    mask_4_2 = rot90(mask_4_2);
end
mask_4_3 = [1 0 0;
            0 0 1;
            0 1 1];
code(9) = elimination_mask_encoding(mask_4_3);
code(10) = elimination_mask_encoding(rot90(mask_4_3));
mask_4 = code(1 : 10);

mask_5_1 = [0 0 0; 
            1 0 0; 
            1 1 0];
mask_5_2 = [1 0 0; 
            1 0 0; 
            1 0 0];
for k = 1 : 4
    code(k * 2 - 1) = elimination_mask_encoding(mask_5_1);
    code(k * 2) = elimination_mask_encoding(mask_5_2);
    mask_5_1 = rot90(mask_5_1);
    mask_5_2 = rot90(mask_5_2);
end
mask_5 = code(1 : 8);

mask_6_1 = [0 0 0; 
            1 0 0; 
            1 0 0];
mask_6_2 = [1 0 0; 
            1 0 0; 
            0 0 0];
for k = 1 : 4
    code(k * 2 - 1) = elimination_mask_encoding(mask_6_1);
    code(k * 2) = elimination_mask_encoding(mask_6_2);
    mask_6_1 = rot90(mask_6_1);
    mask_6_2 = rot90(mask_6_2);
end
mask_6 = code(1 : 8);

mask_7_1 = [0 0 0; 
            1 0 0; 
            0 0 0];
for k = 1 : 4
    code(k) = elimination_mask_encoding(mask_7_1);
    mask_7_1 = rot90(mask_7_1);
end
mask_7 = code(1 : 4);