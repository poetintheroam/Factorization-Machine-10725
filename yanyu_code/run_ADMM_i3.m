datatype = {'w_sparse_W_sparse', 'w_sparse_W_block', ...
    'w_sparse_W_lowrank_sym', 'w_sparse_W_lowrank_asym'};
p = 30;
i = 3;
[objs_coor_container_i3, objs_prox_container_i3, objs_owlqn_container_i3] = test_ADMM(datatype{i}, p);
save('objs_coor_container_i3.mat', 'objs_coor_container_i3')
save('objs_prox_container_i3.mat', 'objs_prox_container_i3')
save('objs_owlqn_container_i3.mat', 'objs_owlqn_container_i3')
