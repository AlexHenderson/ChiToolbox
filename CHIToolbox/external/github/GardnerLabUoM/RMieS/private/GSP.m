function orthonormal_basis = GSP(A , checker)


if nargin < 2 | checker ~= 101
    why
    error(' ;-P ')
end

orthonormal_basis = Gram_Schmidt_Process(A);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function orthonormal_basis = Gram_Schmidt_Process(A)
%
% Gram-Schmidt Process
% 
% Gram_Schmidt_process(A) produces an orthonormal basis for the subspace of
% Eucldiean n-space spanned by the vectors {u1,u2,...}, where the matrix A 
% is formed from these vectors as its columns. That is, the subspace is the
% column space of A. The columns of the matrix that is returned are the 
% orthonormal basis vectors for the subspace. An error is returned if an
% orthonormal basis for the zero vector space is attempted to be produced.
%
% For example, if the vector space V = span{u1,u2,...}, where u1,u2,... are
% row vectors, then set A to be [u1' u2' ...].
%
% For example, if the vector space V = Col(B), where B is an m x n matrix,
% then set A to be equal to B.

matrix_size = size(A);

m = matrix_size(1,1);
n = matrix_size(1,2);

if A == zeros(m,n)
    error('There does not exist any type of basis for the zero vector space.');
elseif n == 1
    orthonormal_basis = A(1:m,1)/norm(A(1:m,1));
else
    flag = 0;

    if is_orthonormal_set(A) == 1
        orthonormal_basis = A;
        flag = 1;
    end

    if flag == 0;
        if rank(A) ~= n
            A = basis_col(A);
        end

        matrix_size = size(A);

        m = matrix_size(1,1);
        n = matrix_size(1,2);

        orthonormal_basis = A(1:m,1)/norm(A(1:m,1));

        for i = 2:n
            u = A(1:m,i);
            v = zeros(m,1);

            for j = 1:(i - 1)
                v = v - dot(u,orthonormal_basis(1:m,j))*orthonormal_basis(1:m,j);
            end

            v_ = u + v;
            orthonormal_basis(1:m,i) = v_/norm(v_);
        end
    end
end


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function basis = basis_col(A)
%
% Bases
% 
% basis_col(A) produces a basis for the subspace of Eucldiean n-space 
% spanned by the vectors {u1,u2,...}, where the matrix A is formed from 
% these vectors as its columns. That is, the subspace is the column space 
% of A. The columns of the matrix that is returned are the basis vectors 
% for the subspace. These basis vectors will be a subset of the original 
% vectors. An error is returned if a basis for the zero vector space is 
% attempted to be produced.
%
% For example, if the vector space V = span{u1,u2,...}, where u1,u2,... are
% row vectors, then set A to be [u1' u2' ...].
%
% For example, if the vector space V = Col(B), where B is an m x n matrix,
% then set A to be equal to B.

matrix_size = size(A);

m = matrix_size(1,1);
n = matrix_size(1,2);

if A == zeros(m,n)
    error('There does not exist a basis for the zero vector space.');
elseif n == 1
    basis = A;
else
    flag = 0;

    if n == 2
        multiple = A(1,2)/A(1,1);
        count = 0;
 
        for i = 1:m
            if A(i,2)/A(i,1) == multiple
                count = count + 1;
            end
        end
 
        if count == m
            basis = A(1:m,1);
            flag = 1;
        end
    end

    if flag == 0
        [ref_A pivot_columns] = ref(A);

        for i = 1:size(pivot_columns,2)
            B(1:m,i) = A(1:m,pivot_columns(1,i));
        end

        basis = B;
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function basis = basis_row(A)
%
% Bases
% 
% basis_row(A) produces a basis for the subspace of Eucldiean n-space 
% spanned by the vectors {u1,u2,...}, where the matrix A is formed from 
% these vectors as its rows. That is, the subspace is the row space of A. 
% The rows of the matrix that is returned are the basis vectors for the 
% subspace. In general, these basis vectors will not be a subset of the 
% original vectors. An error is returned if a basis for the zero vector 
% space is attempted to be produced.
%
% For example, if the vector space V = span{u1,u2,...}, where u1,u2,... are
% row vectors, then set A to be [u1;u2;...].
%
% For example, if the vector space V = Row(B), where B is an m x n matrix,
% then set A to be equal to B.

matrix_size = size(A);

m = matrix_size(1,1);
n = matrix_size(1,2);

if A == zeros(m,n)
    error('There does not exist a basis for the zero vector space.');
elseif m == 1
    basis = A;
else
    flag = 0;

    if m == 2
        multiple = A(2,1)/A(1,1);
        count = 0;

        for i = 1:n
            if A(2,i)/A(1,i) == multiple
                count = count + 1;
            end
        end

        if count == n
            basis = A(1,1:n);
            flag = 1;
        end
    end

    if flag == 0
        A = rref(A);

        for i = 1:m
            if A(i,1:n) == zeros(1,n)
                break
            else 
                basis(i,1:n) = A(i,1:n);
            end
        end
    end
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = is_orthogonal_matrix(P)
%
% Orthogonal Matrices
% 
% is_orthogonal_matrix(P) determines if the matrix P is an orthogonal
% matrix. An error is returned if a matrix that is not square is attempted
% to be determined for orthogonality.

matrix_size = size(P);

m = matrix_size(1,1);
n = matrix_size(1,2);

tolerance = 10^-10;

if m ~= n
    error('Only square matrices can be orthogonal.');
else
    count = 0;

    identity_matrix = P*P';

    if det(P) ~= 0
        for i = 1:m
            if abs(identity_matrix(i,i) - 1) <= tolerance
                count = count + 1;
            else
                break
            end
        end
    end

    if count == m
        result = 1;
    else
        result = 0;
    end
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = is_orthogonal_set(A)
%
% Orthogonal Sets
% 
% is_orthogonal_set(A) determines if a set of vectors in Euclidean n-space 
% is orthogonal. The matrix A is formed from these vectors as its columns. 
% That is, the subspace spanned by the set of vectors is the column space 
% of A. The value 1 is returned if the set is orthogonal. The value 0 is 
% returned if the set is not orthogonal.
%
% For example, if the set of row vectors (u1,u2,...} is to be determined 
% for orthogonality, set A to be equal to [u1' u2' ...].

matrix_size = size(A);

m = matrix_size(1,1);
n = matrix_size(1,2);

tolerance = 10^-10;

if n == 1
        result = 1;
else
    orthogonal_counter = 0;

    for i = 1:n
        for j = 1:n
            if i == j
            else
                if abs(dot(A(1:m,i),A(1:m,j))) <= tolerance
                    orthogonal_counter = orthogonal_counter + 1;
                end
            end
        end
    end

    if orthogonal_counter == factorial(n)/factorial(n - 2);
        result = 1;
    else
        result = 0;
    end
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function result = is_orthonormal_set(A)
%
% Orthonormal Sets
% 
% is_orthonormal_set(A) determines if a set of vectors in Euclidean n-space
% is orthonormal. The matrix A is formed from these vectors as its columns. 
% That is, the subspace spanned by the set of vectors is the column space 
% of A. The value 1 is returned if the set is orthonormal. The value 0 is 
% returned if the set is not orthonormal. An error is returned if a set
% containing only zero vectors is attempted to be determined for
% orthonormality.
%
% For example, if the set of row vectors (u1,u2,...} is to be determined 
% for orthonormality, set A to be equal to [u1' u2' ...].

matrix_size = size(A);

m = matrix_size(1,1);
n = matrix_size(1,2);

tolerance = 10^-10;

if A == zeros(m,n) 
    error('The set that contains just zero vectors cannot be orthonormal.');
elseif n == 1
    if norm(A(1:m,1)) == 1
        result = 1;
    else
        result = 0;
    end
else
    if is_orthogonal_set(A) == 1
        length_counter = 0;
        
        for i = 1:n
            if abs(norm(A(1:m,i)) - 1) <= tolerance
                length_counter = length_counter + 1;
            end
        end

        if length_counter == n
            result = 1;
        else
            result = 0;
        end
    else
        result = 0;
    end
end


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function result = is_symmetric_matrix(A)
%
% Symmetric Matrices
% 
% is_symmetric_matrix(A) determines if the matrix A is a symmetric
% matrix. An error is returned if a matrix that is not square is attempted
% to be determined for symmetry.

matrix_size = size(A);

m = matrix_size(1,1);
n = matrix_size(1,2);

if m ~= n
    error('Only square matrices can be symmetric.');
else
    if A == A'
        result = 1;
    else
        result = 0;
    end
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function unit_vector = normalise(v)
%
% Normalisation
% 
% normalise(v) produces a unit vector that is in the same direction as the 
% vector v. Both column vectors and row vectors can be normalised. An error
% is returned if the zero vector is attempted to be normalised.
%
% For example, normalise([1 1]) produces the vector [1/sqrt(2) 1/sqrt(2)].
% Notice that this new vector is of length 1 whilst remaining in the same
% direction as the vector [1 1].

vector_size = size(v);

m = vector_size(1,1);
n = vector_size(1,2);

if v == zeros(m,n)
    error('The zero vector cannot be normalised.');
else
    unit_vector = v/norm(v);
end


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [U,pivcol,nonpivcol] = ref(A,tol)
%REF    The (R)educed (E)chelon (F)orm of A.
%       Computes the reduced row echelon form of A using partial pivoting.
%
%       Formats:   U = ref(A)
%                  U = ref(A,tol)     User specifies tolerance to determine
%                                     when an entry should be zero.
%                  [U,pivcol] = ref(A)    Also lists the pivot columns of A.
%                  [U,pivcol,nonpivcol] = ref(A)   And the nonpivot columns.

%Written by David Lay, University of Maryland, College Park, 6/20/94
%Based on the original rref(A) program written by Cleve B. Moler in 1985.
%       Version 12/15/96

[m,n] = size(A);
tiny = max(m,n)*eps*max(1,norm(A,'inf'))*10;    %default tolerance for zeros
if (nargin==2), tiny = tol; end                %reset tolerance, if specified 
pivcol = [];
nonpivcol = [];
U = A;
i = 1;                                  %row index
j = 1;                                  %column index
while (i <= m) & (j <= n)
   [x,k] = max(abs(U(i:m,j))); p = k+i-1; %value and row index of next pivot.
   if (x <= tiny)                       % This column is negligible.
      U(i:m,j) = zeros(m-i+1,1);        % So clean up the entries.
      nonpivcol = [nonpivcol j];
      j = j + 1;                        % Pivot row p must be recalculated.
   else                     
      U([i p],j:n) = U([p i],j:n);      % Swap the ith and pth rows.
      U(i,j:n) = U(i,j:n)/U(i,j);       % Divide pivot row by the pivot.
      for k = [1:i-1 i+1:m]             % Replacement operations on other rows.
         U(k,j:n) = U(k,j:n) - U(k,j)*U(i,j:n);
      end
      pivcol = [pivcol j];
      i = i + 1;
      j = j + 1;
   end
end
nonpivcol = [nonpivcol j:n];



end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




