#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    int val;
    struct node* left;
    struct node* right;
}node;

node* make_node(int val);
node* insert(node* root, int val);
node* get(node* root, int val);
int getAtMost(int val, node* root);

int main() {
    node* root = make_node(10);
    insert(root, 5);
    insert(root, 15);
    insert(root, 12);

    node* found = get(root, 5);
    if (found == NULL){
        printf("Not found\n");
    }
    else{
        printf("found\n");
    }

    found = get(root, 50);
    if (found == NULL){
        printf("Not found\n");
    }
    else{
        printf("found\n");
    }

    printf("%d\n", getAtMost(13, root));
    printf("%d\n", getAtMost(4, root));

    return 0;
}