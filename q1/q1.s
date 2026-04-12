.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node: # a0 has val
    addi sp, sp, -16
    sd ra, 0(sp)
    sd a0, 8(sp)
    
    li a0, 24 # 8(4 + padding) + 8(pointer) + 8(pointer)
    call malloc
    
    ld t0, 8(sp)
    sw t0, 0(a0) # val
    sd zero, 8(a0) # start of memory + 8 has node->left = NULL
    sd zero, 16(a0) # node->right = NULL
    
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

insert: # a0 --> root and a1 is val
    ## if (node != NULL) {
        ## if (val < node->val) node->left = insert(node->left, val);
        ## else if (val > node->val) node->right = insert(node->right, val);
        # return node;
    # }
    ## else return make_node(val);
    bnez a0, traverse
    mv a0, a1
    tail make_node

traverse:
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)        # s0 will store our current root
    mv s0, a0

    lw t0, 0(s0) # root->val
    blt a1, t0, left # if a1 < t0 then left
    bgt a1, t0, right # if a1 < t0 then left
        
    mv a0, s0
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    ret

left:
    ld a0, 8(s0) # root->left
    call insert # a1 is val a0 is node->left
    sd a0, 8(s0) # root->left = insert(node->left, val) (a0 is return value)

    j finish_insert

right:
    ld a0, 16(s0) # root->right
    call insert # a1 is val a0 is node->right
    sd a0, 16(s0) # root->right = insert(node->right, val) (a0 is return value)
    j finish_insert

finish_insert:
    mv a0, s0
    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 16
    ret

get: # a0 --> root, a1 -> val
## if (root == NULL || root->val == target)
#      return root;

## if (target > root->val)
#     return search(root->right, target);

# return search(root->left, target);
    beqz a0, returnroot
    lw t0, 0(a0)# root->val
    beq a1, t0, returnroot
    
    bgt a1, t0, getright # if a1 > t0 then right
    
    ld a0, 8(a0)# root->left
    j get
getright:
    ld a0, 16(a0) # root->right
    j get
returnroot:
    ret


getAtMost: # a0 -> val a1 -> root
# int ans = -1;
    
#     while (root != NULL) {
##         if (root->val == val) {
#             return root->val;
#         }
        
##         if (root->val > val) {
#             root = root->left;
#         } 
# #        else {
#             ans = root->val;
#             root = root->right;
#         }
#     }
    
#  return ans;
    addi t0, x0, -1  # ans=-1
whileloop:
    beqz a1, return_ans
    lw t1, 0(a1) # root->val
    
    beq a0, t1, end
    bgt t1, a0, goleft # if t1 > t0 then target
    
    mv t0, t1 # ans = root->val;
    ld a1, 16(a1)   # right
    j whileloop

goleft:
    ld a1, 8(a1)        # root->val > val, must look left
    j whileloop

end:
    ret # a0 is already val

return_ans:
    mv a0, t0
    ret
